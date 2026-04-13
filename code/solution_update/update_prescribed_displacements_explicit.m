function x = update_prescribed_displacements_explicit(dofprescribed,x0,x,...
                   xlamb,presc_displacement,time_np1, total_time)

% Calculate the prescribed displacement at the NEW time step (t_n+1)
AppliedDisp = presc_displacement(dofprescribed);

% Linear ramp: u(t) = (Total_U / Total_Time) * current_time
ramp = time_np1 * (AppliedDisp / total_time);

% Update current coordinates based on the initial reference + ramp
x(dofprescribed) = x0(dofprescribed) + ramp;

end
