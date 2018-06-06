function [message] = set_initialpose(x, y, yaw)

covariance = [0.25, 0.0, 0.0, 0.0, 0.0, 0.0, ...
             0.0, 0.25, 0.0, 0.0, 0.0, 0.0, ...
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
             0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
             0.0, 0.0, 0.0, 0.0, 0.0, 0.06853891945200942];

pub = rospublisher('/amcl_pose');

message = rosmessage('geometry_msgs/PoseWithCovarianceStamped');
message.Pose.Covariance = covariance;
message.Pose.Pose.Position.X = x;
message.Pose.Pose.Position.Y = y;
q = eul2quat([yaw,0,0]);
message.Pose.Pose.Orientation.W = q(1);
message.Pose.Pose.Orientation.X = q(2);
message.Pose.Pose.Orientation.Y = q(3);
message.Pose.Pose.Orientation.Z = q(4);

send(pub, message)

end

