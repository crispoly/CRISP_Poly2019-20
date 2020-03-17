%==========================================================================
% >>>>>>>>>>>>>>>>>> FUNCTION PF-L: DRIVING_ACTUATORS <<<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2016.

% DESCRIPTION: This function will send the trajectory information (joint
% position, velocity and acceleration, and possibly torque) to the joints
% (servos) controllers. This function is hightly dependent on the robot
% servos, and servos controller used. It should be modified for specific
% robots. The function bellow works for the AX-12A SMART robotic arm. Refer
% to section 4 of documentation for details.
%==========================================================================
%START OF ADAPTATION (BY DIEGO)
function PF_Driving_Actuators(servos_id, Theta, speed, pause_time, ...
                                         DEFAULT_PORTNUM, DEFAULT_BAUDNUM)

%>>>1: Get correction for joint 2 and 3, Call Function E: POSITION ERROR HANDLING.
%Theta(2:3) = Error_Handling(conf, Theta(2:3));


%>>>3: Attempt load the corrected ThetaOld_Motor from appdata(if exists)
%If the difference between Theta_Old and goal Theta is zero, the motor
%will skip that servo, saving time (no pause time for a servo that is
%already in the desired position).
ThetaOld = getappdata(0,'ThetaOld_Motor'); %Load Theta Old in Motor set
if isempty(ThetaOld)    %Otherwise, read theta from servos and write
    try
      Theta_Com = Get_Servos_Angles(servos_id, DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
      Theta_World = Angles_Conversion(Theta_Com, (1:5), 8);
      Theta_Motor = Angles_Conversion(Theta_World, (1:5), 3);
      setappdata(0,'ThetaOld_Motor',Theta_Motor);
    catch
        setappdata(0,'ThetaOld_Motor',Theta);
    end
end

%>>>4: Get ThetaOld and Theta in set World and FK
ThetaOld = getappdata(0,'ThetaOld_Motor'); %Load Theta Old in Motor set
ThetaOld_World = Angles_Conversion(ThetaOld, (1:4), 7);
ThetaOld_FK = Angles_Conversion(ThetaOld_World, (1:4), 1);
Theta_World = Angles_Conversion(Theta, (1:4), 7);
Theta_FK = Angles_Conversion(Theta_World, (1:4), 1);
%>>>5: WORK ON THE TRAJECTORY OPTION
switch traj_opt
    case 1 	%trajectory option: Straight Line
    [old_coord, ~] = Forward_Kinematics_DH(ThetaOld_FK, d, a, Alpha);
    [act_coord, ~] = Forward_Kinematics_DH(Theta_FK(1:4), d, a, Alpha);
    
    %N: number of knots for a straight line
    n = round(sqrt(abs(old_coord(1)-act_coord(1))^2 + ... 
                   abs(old_coord(1)-act_coord(1))^2 + ...
                   abs(old_coord(1)-act_coord(1))^2)/50,0);
               %50 mm: fixed distance segment.
   if n<2
       n=2;
   end
    
    X = linspace(old_coord(1) , act_coord(1),n); 
    Y = linspace(old_coord(2) , act_coord(2),n);
    Z = linspace(old_coord(3) , act_coord(3),n);
    t4 = linspace(ThetaOld(4),Theta(4),n); %list with angles for joint 4;
    t5 = linspace(ThetaOld(5),Theta(5),n); %list with angles for gripper;
    t1 =zeros(1,n);
    t2 = zeros(1,n);
    t3 = zeros(1,n);
    for k = 1:1:n
        [conf, ~, ~] = Conf_Const_Reach([X(k), Y(k), Z(k)]);
        Theta_World = Inverse_Kinematics(conf, [X(k), Y(k), Z(k)]);
        Theta_Motor = Angles_Conversion(Theta_World, (1:3), 3);
        t1(1,k) = Theta_Motor(1); % list with angles for joint 1;
        t2(1,k) = Theta_Motor(2); % list with angles for joint 2;
        t3(1,k) = Theta_Motor(3); % list with angles for joint 3;
    end
    Motor_Angle = [t1; t2; t3; t4; t5]; %Motor_Angle: actual value used to drive servos  
    steps = n;  %Has n knots on the path.
    
    %>>>Determining the speed of each joint for each knot:
    %The straight line moves the servos as if they were a sequency of
    %joint interpolated motion, so for each knot there is a list of speed
    %to make all servos finish the movement at the same time when reach the
    %knot.
    
    %1 unit in speed is equivalent to 0.111rpm, so a speed of 20 > 2.22rpm
    speed_unit_dpm = 39.96;  %1 unit of speed = 39.96degrees/min
    %the time for the first joint with the speed inputted
    %check all ThetaOld and Theta and takes the biggest difference betwen
    %then to attribute.
    time_comp = max(abs(ThetaOld-Theta))/speed_unit_dpm;%time for completion
    if time_comp == 0
        time_comp = 1;
    end
    
    for t = 2:1:n
        for q = 1:1:length(Theta)
            %distance = speed*time
            %ThetaOld(q)-Theta(q) is the angle distance to sweep for joint q.
            %Speed = 39.96*speed
            %time is calculated in minutes

            %all the other joints should make the movement in the same time.
            if q == 1
                Joints_Speed(t,q) = speed;
            else
                Angle_Distance = abs(Motor_Angle(q,t) - Motor_Angle(q,(t-1)));
                %#check what happens when angle_distance is zero
                Joints_Speed(t,q) = abs((Angle_Distance/time_comp)/speed_unit_dpm);
            end
        end
    end
    case 2  %trajectory option: Uncoordinated
    %For uncoordinated joint just send all servos for their position with a
    %constant speed (they will finish their movement in differnt moments).
    Joints_Speed = abs(ones(1,length(Theta)).*speed);
    steps = 2;  %No knots in the path, go directly to goal.
    Motor_Angle = Theta;    %Motor_Angle: actual value used to drive servos  
    
    case 3 %trajectory option 3: Joint Interpolated
    %NOTE: All the joints will move at the same time, and finish at the
    %same time. This part computes the difference between the ThetaOld and
    %Theta and convert to speed necessary to make all servos finish at
    %once. The joint with biggest difference in angle (actual theta goal theta),
    %will receive the speed inputted in this function.
    %1 unit in speed is equivalent to 0.111rpm, so a speed of 20 > 2.22rpm
    speed_unit_dpm = 39.96;  %1 unit of speed = 39.96degrees/min
    steps = 2;  %No knots in the path, go directly to goal.
    %the time for the first joint with the speed inputted
    %check all ThetaOld and Theta and takes the biggest difference betwen
    %then to attribute.
    time_comp = max(abs(ThetaOld-Theta))/speed_unit_dpm;%time for completion
    for q = 1:1:length(Theta)
        %distance = speed*time
        %ThetaOld(q)-Theta(q) is the angle distance to sweep for joint q.
        %Speed = 39.96*speed
        %time is calculated in minutes
        
       %all the other joints should make the movement in the same time.
        if q == 1
            Joints_Speed(q) = speed;
        else
            Angle_Distance = abs(ThetaOld(q)-Theta(q));
            Joints_Speed(q) = abs((Angle_Distance/time_comp)/speed_unit_dpm);
        end
    end
    Motor_Angle = Theta;    %Motor_Angle: actual value used to drive servos    
        
    case 4 %trajectory option 4: Sequential
    %Note: The speed is the same for all servos (inputted speed)
    steps = 2;   %No knots in the path, go directly to goal.
    Joints_Speed = abs(ones(1,length(Theta)).*speed);
    Motor_Angle = Theta;    %Motor_Angle: actual value used to drive servos 
   
    %List of pause for each joint, the program will wait until the the
    %pause is theoretically calculated based on the speed, for future
    %implementation, read the servo position to know if the servo reached
    %the goal.
    Angle_difference = Theta - ThetaOld;
    Pause_time = abs(Angle_difference./(Joints_Speed*0.666));
    %1 unit = 0.666 degrees/sec
    %Eg.: For a difference of 60 degrees and speed of 30 >pause = 3.003sec
    
end

%>>>X: Load the dynamixel library and get response from motors
loadlibrary('dynamixel','dynamixel.h');
response = calllib('dynamixel', 'dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
pause on


for u = 2:1:steps % n
    for i = 1:1:5   %5: is the number of joints + the gripper
        %If the difference between actual position and goal postion is zero
        if traj_opt == 1 % For Straight line, the difference between thetaOld
                         %and goal theta:
            if abs(Motor_Angle(i, u) - Motor_Angle(i,(u-1)))==0
                continue %skip that servo (no need for moving it)
            end
            Drive_Angle = Motor_Angle(:,u)';
        else
            if ThetaOld(i)-Motor_Angle(i)==0
                continue %skip that servo (no need for moving it)
            end
            Drive_Angle = Motor_Angle;
        end
    
    %>>>1: Determining the servos id.
        switch i
            case 1
                id = servos_id(1);
            case 2
                id = servos_id(2:3);
            case 3
                id = servos_id(4:5);
            case 4
                id = servos_id(6);
            case 5
                id = servos_id(7);
        end
        %END OF ADAPTATION
        response = 1; %#delete
        % >>> TWO SERVOS
        %GABRIEL CODE
        if length(id)==2

            %There should only be 2 Dynamixels total
            numberOfDynamixels = length(id);
            if response == 1

                % Phase allows us to position the servos
                % in some relationship to theta.
                phase = zeros(1,2);
                for r = 1:numberOfDynamixels
                    phase(1,r) = (2 * pi) * (r)/numberOfDynamixels;
                end

                goalPosition = zeros(1,2);
                % Convert theta to goal position
                for r = 0:numberOfDynamixels-1
                    goalPosition(1, r+1) =int16((Drive_Angle(i)+r*(300-2*Drive_Angle(i))) * (512/150));
                end


                 % NEW%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

                %Using calllib function of MATLAB, dxl_read_word function is called from ynamixel API.
                %ID means the ID value of currently connected Dynamixel.
                %P_PRESENT_POSITION value declared, in advanec, the address value (36), which saves the present position of Dynamixel.
                P_PRESENT_POSITION=36;
                try
                    PresentPos1 = int32(calllib('dynamixel','dxl_read_word',id(1),P_PRESENT_POSITION));
                    PresentPos2 = 1024 - (int32(calllib('dynamixel','dxl_read_word',id(2),P_PRESENT_POSITION)));
                catch
                    PresentPos1 = goalPosition(1);
                    PresentPos2 = 1024 - goalPosition(1);
                end
        %         fprintf('pos1= %d \n',PresentPos1);
        %         fprintf('pos2= %d \n',PresentPos2);
                delta = abs(PresentPos1 - PresentPos2);
                if PresentPos1>PresentPos2
                    goalPosition(1, 2)=(goalPosition(1, 2)+ delta);
                else
                    goalPosition(1, 1)=(goalPosition(1, 1)+ delta);
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



                %Broadcast ID
                calllib('dynamixel','dxl_set_txpacket_id', 254);

                %Length is 14
                %That handles position and speed for two dynamixels
                calllib('dynamixel','dxl_set_txpacket_length',14);

                %SyncWrite instruction
                calllib('dynamixel','dxl_set_txpacket_instruction',131);

                %Starting address (goal position)
                calllib('dynamixel','dxl_set_txpacket_parameter',0, 30);

                %length of data to write to each dynamixel
                %We're writing position and speed = 4 bytes
                calllib('dynamixel','dxl_set_txpacket_parameter',1, 4);

                %Parameters for syncwrite 1st dynamixel
                % id | position | speed
                %ID 
                calllib('dynamixel','dxl_set_txpacket_parameter',2, id(2));
                %Position
                lowByte = calllib('dynamixel','dxl_get_lowbyte', goalPosition(1,1));
                highByte = calllib('dynamixel','dxl_get_highbyte', goalPosition(1,1));
                calllib('dynamixel','dxl_set_txpacket_parameter',3, lowByte);
                calllib('dynamixel','dxl_set_txpacket_parameter',4, highByte);
                %Speed
                lowByte = calllib('dynamixel','dxl_get_lowbyte', Joints_Speed(i));
                highByte = calllib('dynamixel','dxl_get_highbyte', Joints_Speed(i));
                calllib('dynamixel','dxl_set_txpacket_parameter',5, lowByte);
                calllib('dynamixel','dxl_set_txpacket_parameter',6, highByte);

                %Parameters for syncwrite 2nd dynamixel 
                % id | position | speed
                %ID
                calllib('dynamixel','dxl_set_txpacket_parameter',7, id(1));
                %Position
                lowByte = calllib('dynamixel','dxl_get_lowbyte', goalPosition(1,2));
                highByte = calllib('dynamixel','dxl_get_highbyte', goalPosition(1,2));
                calllib('dynamixel','dxl_set_txpacket_parameter',8, lowByte);
                calllib('dynamixel','dxl_set_txpacket_parameter',9, highByte);
                %Speed 
                lowByte = calllib('dynamixel','dxl_get_lowbyte', Joints_Speed(i));
                highByte = calllib('dynamixel','dxl_get_highbyte', Joints_Speed(i));
                calllib('dynamixel','dxl_set_txpacket_parameter',10, lowByte);
                calllib('dynamixel','dxl_set_txpacket_parameter',11, highByte);

                %transmit
                calllib('dynamixel','dxl_tx_packet');      

            else
                disp('Failed to open USB2Dynamixel!');
            end
        end

        % >>>>>>ONE SERVO
          if length(id)==1
            %Check the list of library functions
        %     libfunctions('dynamixel');

            if response == 1
                %Call the functions-----------------------------------------------
        %          theta = 150
        %          GoalSpeed = 100
        %          id=1;
            %     index = 3;
            %     a= [1 2 3];
            %     GoalPos(a)= [1023 0 512];
                 P_GOAL_POSITION=30;
                 P_Goal_Speed=32;

                GoalPos= Drive_Angle(i) * (1024/300);

                %Write goal position%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                %P_GOAL_POSITION value declared, in advance, the adress value (30), which belongs to GOAL_POSITION of the Dynamixel's Control Table.
                %GoalPos(index) declares GoalPosition value by array, and the relevant value is transmitted whenever the index is changed

                calllib('dynamixel','dxl_write_word',id,P_Goal_Speed,Joints_Speed(i));
                calllib('dynamixel','dxl_write_word',id,P_GOAL_POSITION,GoalPos); %GoalPos(index)

                else
                disp('Failed to open USB2Dynamixel!');
            end
          end
          if traj_opt==4    %If traj_opt is sequential use the pause of the list
              pause(Pause_time(i)+pause_time); %The pause is between joints
          else
              pause(pause_time); %Pause for finish sending information (in seconds)
          end
    end
    
    %For one knot to another the program needs pause to wait the arm reach
    %the knot. This pause is theoretical (time_comp) (all joint finish at
    %the same time).
    %In future updates, read the position of the servo and check if it
    %reached goal(knot). That option was not chosen here because read
    %joints is unstable (does not work all the time).
    if traj_opt == 1
        pause(time_comp); %The pause here is between knots
    end
end
calllib('dynamixel','dxl_terminate');  %Close Device
unloadlibrary('dynamixel'); %Unload Library when the program is ended

%Update ThetaOld_Motor
setappdata(0,'ThetaOld_Motor',Theta);
end
