rosaction list
message = set_initialpose(0,0,0);
xp = [5.5 5 4 2 1.8 0];
yp = [1 -4 -1 -1 -2.5 0] ;
yawp =[0 90 180 180 90 0];

for i = 1:length(xp)
    x=xp(i);
    y=yp(i);
    yaw=yawp(i);
[client,goalMsg] = rosactionclient('/move_base');

waitForServer(client);
client.IsServerConnected

client.ActivationFcn=@(~)disp('Goal active');
client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f, Y=%.2f, yaw=%.2f, pitch=%.2f, roll=%.2f  \n',msg.BasePosition.Pose.Position.X,...
    msg.BasePosition.Pose.Position.Y,quat2eul([msg.BasePosition.Pose.Orientation.W,...
    msg.BasePosition.Pose.Orientation.X,msg.BasePosition.Pose.Orientation.Y, ...
    msg.BasePosition.Pose.Orientation.Z]));
client.FeedbackFcn=@(~,msg)fprintf('Feedback: X=%.2f\n',msg.BasePosition.Pose.Position.X);
client.ResultFcn=@(~,res)fprintf('Result received: State: <%s>, StatusText: <%s>\n',res.State,res.StatusText);

goalMsg.TargetPose.Header.FrameId='map'
goalMsg.TargetPose.Pose.Position.X = x;
goalMsg.TargetPose.Pose.Position.Y = y;
q=eul2quat([yaw, 0, 0]);
goalMsg.TargetPose.Pose.Orientation.W=q(1);
goalMsg.TargetPose.Pose.Orientation.X=q(2);
goalMsg.TargetPose.Pose.Orientation.Y=q(3);
goalMsg.TargetPose.Pose.Orientation.Z=q(4);
[resultMsg,~,~] = sendGoalAndWait(client,goalMsg);

cancelAllGoals(client)
delete(client)
clear goalMsg
end
rosshutdown()