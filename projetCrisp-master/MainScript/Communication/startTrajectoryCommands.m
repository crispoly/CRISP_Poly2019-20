function [ is_complete ] = startTrajectoryCommands( )

is_complete = true;

global map enabled_ddl commandTrajectory commandTimeTrajectory loopingMode
NumberOfPoints = min(20,size(commandTrajectory,1));
    if NumberOfPoints > 0
        TrajectoryP = zeros(NumberOfPoints,6);
        for i = 1:NumberOfPoints
            TrajectoryP(i,1) = 2048000/pi*commandTrajectory(i,1);
            TrajectoryP(i,2) = -2048000/pi*(commandTrajectory(i,2)-pi/2);
            TrajectoryP(i,3) = 1280000/pi*commandTrajectory(i,3);
            TrajectoryP(i,4) = -1280000/pi*commandTrajectory(i,4);
            %TrajectoryP(i,5) = k5*commandTrajectory(i,5);
            %TrajectoryP(i,6) = k6*commandTrajectory(i,6);
            TrajectoryP(i,5) = NaN;
            TrajectoryP(i,6) = NaN;           
            for j = 1:6 % Enregistrer les position dans les user value du controleur
                if (enabled_ddl(j))
                    write_dg(map, strcat("c_",num2str(j)), create_dg(j+1, 9, i+8, 2, TrajectoryP(i,j)), 1);
                end
            end
            pause(1)
        end
         for j = 1:6 % Enregistrer le nombre de positions
              if (enabled_ddl(j))
                    write_dg(map, strcat("c_",num2str(j)), create_dg(j+1, 9, 4, 2, NumberOfPoints), 1);
              end
         end
         pause(1)
         for j = 1:6 % Enregistrer le temps entre les points
              if (enabled_ddl(j))
                    write_dg(map, strcat("c_",num2str(j)), create_dg(j+1, 9, 7, 2, commandTimeTrajectory*1000), 1);
              end
         end
         pause(1)
         for j = 1:6 % Enregistrer le temps entre les points
              if (enabled_ddl(j))
                    write_dg(map, strcat("c_",num2str(j)), create_dg(j+1, 9, 8, 2, loopingMode), 1);
              end
         end
         pause(2)
         for j = 1:6 % Jouer la trajectoire
              if (enabled_ddl(j))
                    write_dg(map, strcat("c_",num2str(j)), create_dg(j+1, 9, 3, 2, 10), 1);
              end
         end
    end
end

