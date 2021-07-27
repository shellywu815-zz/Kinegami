% Dubins Path Plotting
% Last edited 7/22/2021 by Lucien Peach

function [TransformStruct] = DubinsPlot(TransformStruct, infostruct, index, i)

% TransformStruct provides information about frames
% infostruct provides information about fold parameters
% i used for TransformStruct indexing
% index used for infostruct indexing

% Using same index scheme as for DubinsTube: 
% index = elbow1
% index+1 = twist
% index+2 = tube
% index+3 = elbow2

tvec = infostruct(index).tvec;
t = infostruct(index).t;

% Origin point (Od)
TransformStruct(i).path(:, 1) = TransformStruct(i).Od(:, 4);
TransformStruct(i).newpath(:, 1) = TransformStruct(i).Od(:, 4);
TransformStruct(i).newpath(:, 4) = TransformStruct(i+1).Op(:, 4);

% Elbow1 Parameters and Path Plotting
% ------------------------------------------------------------------------

% Pull ap from initial frame
ap = TransformStruct(i).Od(:, 1);

% Determine ad based on theta - rotation matrix depends on axis of rotation
% First, we must find w
wp = cross(ap, tvec);

% Use ap, rotationalmatrix, and w to determine ad for first elbow
ad = rotationalmatrix(wp, infostruct(index).theta);
ad = ad*ap;

% Factor in h1 and h2 offsets to determine positions for plotting
TransformStruct(i).path(:, 2) = (infostruct(index).h1 + infostruct(index).dw)*ap ...
    + TransformStruct(i).path(:, 1);
TransformStruct(i).path(:, 3) = (infostruct(index).h2 + infostruct(index).dw)*ad ...
    + TransformStruct(i).path(:, 2);

TransformStruct(i).newpath(:, 2) = (infostruct(index).h1 + infostruct(index).dw)*ap ...
    + TransformStruct(i).newpath(:, 1);

% Twist Parameters and Path Plotting
% ------------------------------------------------------------------------

% Frame direction remains consistent - ad from elbow1
% For purposes of initial iteration, twist functions similarly to tube but
% with an adjusted height calculation
TransformStruct(i).path(:, 4) = (infostruct(index+1).h1 + infostruct(index+1).h2 + ...
    infostruct(index+1).h)*ad + TransformStruct(i).path(:, 3);


% Tube Parameters and Path Plotting
% ------------------------------------------------------------------------

% Frame direction remains consistent - ad from elbow1
TransformStruct(i).path(:, 5) = (infostruct(index+2).h1 + infostruct(index+2).h2 + ...
    infostruct(index+2).h)*ad + TransformStruct(i).path(:, 4);


% Elbow2 Parameters and Path Plotting
% ------------------------------------------------------------------------

% Pull ap from elbow1 ad
ap2 = ad;
a_next = TransformStruct(i+1).Op(:, 1);

% Determine new ad based on theta
wp2 = cross(ap2, a_next);
ad = rotationalmatrix(wp2, infostruct(index+3).theta);
ad = ad*ap2;

% Factor in h1 and h2 offsets
TransformStruct(i).path(:, 6) = (infostruct(index+3).h1 + infostruct(index+3).dw)*ap2 ...
    + TransformStruct(i).path(:, 5);
TransformStruct(i).path(:, 7) = (infostruct(index+3).h2 + infostruct(index+3).dw)*ad ...
    + TransformStruct(i).path(:, 6);


% Newpath
% aframe = -TransformStruct(i+1).Op(:, 1);
% TransformStruct(i).newpath(:, 3) = TransformStruct(i).newpath(:, 4) + ...
%     (infostruct(index+3).h2 + infostruct(index+3).dw)*aframe;

TransformStruct(i).newpath(:, 3) = TransformStruct(i).newpath(:, 2) + ...
    t.'+ (infostruct(index+3).dw + infostruct(index).dw)*tvec.';


% Should now create a "path" represented by segments 
handle = plot3(TransformStruct(i).path(1, 1:7), TransformStruct(i).path(2, 1:7), ...
    TransformStruct(i).path(3, 1:7), 'LineWidth', 4, 'Color', 'k');
handle.Annotation.LegendInformation.IconDisplayStyle = 'off';

handle2 = plot3(TransformStruct(i).newpath(1, 1:4), TransformStruct(i).newpath(2, 1:4), ...
    TransformStruct(i).newpath(3, 1:4), 'LineWidth', 3, 'Color', 'k');
handle2.Annotation.LegendInformation.IconDisplayStyle = 'off';
    

end