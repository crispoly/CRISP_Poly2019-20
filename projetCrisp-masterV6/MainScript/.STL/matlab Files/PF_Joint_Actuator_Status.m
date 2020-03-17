%==========================================================================
% >>>>>>>>>>>>>>>> FUNCTION PF-K: JOINT ACTUATOR STATUS <<<<<<<<<<<<<<<<<<
%==========================================================================
% Created by Diego Varalda de Almeida
% version 1.0 - March 30th, 2015.

% DESCRIPTION: This function will check with the servo controller the
% actuator status. If an error has occurred in the servo, being it by
% overheating or communication problem the function that stops the robot is
% triggered. This function is hightly dependent on the robot servos, and
% servos controller used. It should be modified for specific robots. The
% function bellow works for the AX-12A SMART robotic arm. Refer to section
% 4 of documentation for details.
%==========================================================================
% >>>>>>>>>>>>>> FUNCTION F: SERVO ERRORS AND STATUS <<<<<<<<<<<<<<<<<<
function Status = PF_Joint_Actuator_Status(id,DEFAULT_PORTNUM,DEFAULT_BAUDNUM)

    %Load Library
    loadlibrary('dynamixel','dynamixel.h');
    %Check the list of library functions
    libfunctions('dynamixel');
    %
%     DEFAULT_PORTNUM = 9;  %//COM9
%     DEFAULT_BAUDNUM = 1;  %//1Mbps
    
    id=13;
    %open device
    res = calllib('dynamixel','dxl_initialize',DEFAULT_PORTNUM,DEFAULT_BAUDNUM);

    P_Status=16;
    Status = int32(calllib('dynamixel','dxl_read_word',id,P_Status))
    
        
    %Close Device
    calllib('dynamixel','dxl_terminate');
    
    %Unload Library when the program is ended
    unloadlibrary('dynamixel');
    
end
%%
function PrintErrorCode(DEFAULT_PORTNUM, DEFAULT_BAUDNUM)
%FUNCTION DESCRIPTION:
        %1 - Load Library;
        %2 - Attribute constant values;
        %3 - Get return from Dynamixel library;
        %4 - Print return

% Load Library
    loadlibrary('dynamixel','dynamixel.h');
    %Check the list of library functions
    libfunctions('dynamixel');
    %
    DEFAULT_PORTNUM = 9;  %//COM9
    DEFAULT_BAUDNUM = 1;  %//1Mbps

    %open device
    response = calllib('dynamixel','dxl_initialize', DEFAULT_PORTNUM, DEFAULT_BAUDNUM);
% --------------------------------------------------------------------------------------------

if response == 1
    
    global ERRBIT_VOLTAGE

    ERRBIT_VOLTAGE     = 1;

    global ERRBIT_ANGLE

    ERRBIT_ANGLE       = 2;

    global ERRBIT_OVERHEAT

    ERRBIT_OVERHEAT    = 4;

    global ERRBIT_RANGE

    ERRBIT_RANGE       = 8;

    global ERRBIT_CHECKSUM

    ERRBIT_CHECKSUM    = 16;

    global ERRBIT_OVERLOAD

    ERRBIT_OVERLOAD    = 32;

    global ERRBIT_INSTRUCTION

    ERRBIT_INSTRUCTION = 64;

     if int32(calllib('dynamixel','dxl_get_rxpacket_error', ERRBIT_VOLTAGE))==1

         disp('Input Voltage Error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_ANGLE))==1

         disp('Angle limit error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_OVERHEAT))==1

         disp('Overheat error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_RANGE))==1

         disp('Out of range error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_CHECKSUM))==1

         disp('Checksum error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_OVERLOAD))==1

         disp('Overload error!');

     elseif int32(calllib('dynamixel','dxl_get_rxpacket_error',ERRBIT_INSTRUCTION))==1

         disp('Instruction code error!');
     else
         disp('tu es dans la merde!');
     
     end
    
 else
        disp('Failed to open USB2Dynamixel!');
%------------------------------------------------------------
%%
% %Close Device
% calllib('dynamixel','dxl_terminate');
% 
% %Unload Library when the program is ended
% unloadlibrary('dynamixel');
end
end

 %%
 function PrintCommStatus( CommStatus )

 
global COMM_TXSUCCESS

COMM_TXSUCCESS     = 0;

global COMM_RXSUCCESS

COMM_RXSUCCESS     = 1;

global COMM_TXFAIL

COMM_TXFAIL        = 2;

global COMM_RXFAIL

COMM_RXFAIL        = 3;

global COMM_TXERROR

COMM_TXERROR       = 4;

global COMM_RXWAITING

COMM_RXWAITING     = 5;

global COMM_RXTIMEOUT

COMM_RXTIMEOUT     = 6;

global COMM_RXCORRUPT

COMM_RXCORRUPT     = 7;

switch(CommStatus)

    case COMM_TXFAIL

        disp('COMM_TXFAIL : Failed transmit instruction packet!');

    case COMM_TXERROR

        disp('COMM_TXERROR: Incorrect instruction packet!');

    case COMM_RXFAIL

        disp('COMM_RXFAIL: Failed get status packet from device!');

    case COMM_RXWAITING

        disp('COMM_RXWAITING: Now recieving status packet!');

    case COMM_RXTIMEOUT

        disp('COMM_RXTIMEOUT: There is no status packet!');

    case COMM_RXCORRUPT

        disp('COMM_RXCORRUPT: Incorrect status packet!');

    otherwise

        disp('This is unknown error code!');

end

end