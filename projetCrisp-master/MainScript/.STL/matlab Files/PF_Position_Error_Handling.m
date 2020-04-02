%==========================================================================
% >>>>>>>>>>>>>> FUNCTION PF-J: POSSITION ERROR HANDLING <<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Juan
% version 1.0 - March 30th, 2015.

% DESCRIPTION: This function will calibrate the joint position in order to
% correct end-effector cartesian position. This function is hightly
% dependent on the robot servos, and servos controller used. It should be
% modified for specific robots. The function bellow works for the AX-12A
% SMART robotic arm. Refer to section 4 of documentation for details.
%==========================================================================
function [q_corrected] = PF_Position_Error_Handling(conf,q)
%Handles the error in position of the end-effector.
%This function return an angle correction for joint 2 and 3 only.
%Theta is a list of original theta 2 and theta 3 in Motor set, 
%so should be Theta_Corrected.

    %Theta 2 shoulder joint
    Theta2=q(1);
    %Theta 3 elbow joint
    Theta3=q(2);

    if (conf==1) %Distant configuration
        %Square equation for Gap prediction
        GapTheta2=(115.132912)+(-1.448342*Theta2)+(-0.306866*Theta3)+...
            (0.004168*Theta2^2)+(0.000598*Theta3^2)+(0.001314*Theta2*Theta3);
        GapTheta3=(-134.198070)+(1.675013*Theta2)+(0.185828*Theta3)+...
            (-0.005386*Theta2^2)+(-0.001117*Theta3^2)+(-0.000037*Theta2*Theta3);
    else% Nearby configuration
%Square equation for Gap prediction
        GapTheta2=(-118.996908)+(0.712828*Theta2)+(0.194545*Theta3)+...
            (-0.001145*Theta2^2)+(-0.000176*Theta3^2)+(-0.000396*Theta2*Theta3);
        GapTheta3=(-91.307913)+(0.652638*Theta2)+(0.288263*Theta3)+...
            (-0.001171*Theta2^2)+(-0.000324*Theta3^2)+(-0.000794*Theta2*Theta3);
    end
    
    
    % Angle correction
    Theta_2_correct=Theta2-GapTheta2;
    Theta_3_correct =Theta3-GapTheta3;
    
    q_corrected=[Theta_2_correct,Theta_3_correct];
end
