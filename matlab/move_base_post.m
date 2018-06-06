% Read the image
ifile = '~/map.pgm';   % Image file name
I=imread(ifile);

% Create a bag file object with the file name
bag = rosbag('~/catkin_ws/src/mrc_hw6/rosmap.bag')
 
% Set the size scaling
xWorldLimits = [-10 9.2];
yWorldLimits = [-10 9.2];
RI = imref2d(size(I),xWorldLimits,yWorldLimits)

% Select by topic
amcl_select = select(bag,'Topic','/amcl_pose');
 
% Create time series object
ts_amcl = timeseries(amcl_select,'Pose.Pose.Position.X','Pose.Pose.Position.Y',...
    'Pose.Pose.Orientation.W','Pose.Pose.Orientation.X',...
    'Pose.Pose.Orientation.Y','Pose.Pose.Orientation.Z');

% Select by topic
goal_select = select(bag,'Topic','/move_base/goal');
 
% Create time series object
ts_goal = timeseries(goal_select,'Goal.TargetPose.Pose.Position.X','Goal.TargetPose.Pose.Position.Y',...
    'Goal.TargetPose.Pose.Orientation.W','Goal.TargetPose.Pose.Orientation.X',...
    'Goal.TargetPose.Pose.Orientation.Y','Goal.TargetPose.Pose.Orientation.Z');

%%

% Plot
figure(3);
clf()
imshow(flipud(I),RI)
set(gca,'YDir','normal')
hold
plot(ts_amcl.Data(:,1),ts_amcl.Data(:,2),'k')
plot(ts_goal.Data(:,1),ts_goal.Data(:,2),'ro')