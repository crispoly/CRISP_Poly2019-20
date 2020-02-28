addpath(genpath('Communication'));

%Test_communications

global enabled_ddl;
enabled_ddl = [0, 0, 0, 1, 0, 0];

init_communications();

% v = [200, NaN, NaN, NaN, NaN, NaN]; 
% set_v(v);
% pause()
% motor_stop([1 0 0 0 0 0]);


% q = [NaN, 0, NaN, NaN, NaN, NaN]; 
% set_p(q);
% pause();
% q = [NaN, 25600, NaN, NaN, NaN, NaN]; 
% set_p(q);


%% Test set_actual_p
ls = get_ls();
p = get_p();
t = get_t();
% for i = 1:6
%     if enabled_ddl(i)
%         fprintf('ls_1_1: %d ls_1_2: %d pos_1: %d t_1: %d\n', ls(1,1), ls(1,2), p(1), t(1));
%         fprintf('ls_2_1: %d ls_2_2: %d pos_2: %d t_2: %d\n', ls(2,1), ls(2,2), p(2), t(2));
%         fprintf('ls_3_1: %d ls_3_2: %d pos_3: %d t_3: %d\n', ls(3,1), ls(3,2), p(3), t(3));
%         fprintf('ls_4_1: %d ls_4_2: %d pos_4: %d t_4: %d\n', ls(4,1), ls(4,2), p(4), t(4));
%     end
% end

% pause(0.1);

% for i = 1:6
%     if enabled_ddl(i)
%         write_dg(i, 5, 159, 0, 7);
%     end
% end

send_other(create_dg(2, 5, 1, 0, 0));
send_other(create_dg(3, 5, 1, 0, 0));
send_other(create_dg(4, 5, 1, 0, 0));
send_other(create_dg(5, 5, 1, 0, 0));

for i = 1:4
    set_p_rel([NaN, NaN, NaN, 80000, NaN, NaN]);
    pause(2);
    set_p_rel([NaN, NaN, NaN, -80000, NaN, NaN]);
    pause(2);
end

% set_p([256000, NaN, NaN, NaN, NaN, NaN]);

for i = 1:1000
   ls = get_ls();
   p = get_p();
   t = get_t();

  if enabled_ddl(1)
      fprintf(strcat('ls_1_1: %d '), ls(1,1));
      fprintf(strcat(' ls_1_2: %d '), ls(1,2));
      fprintf(strcat(' pos_1: %d '), p(1));
      fprintf(strcat(' t_1: %d \n'), t(1));
  end

   pause(0.1);
end



deinit_communications();


