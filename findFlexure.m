%Import data
d = load('flexure3.dat');

%generate some random indices
r = ceil(length(d) * rand(10000000,2)) ;

%drop difference pairs that are too close together in time
r = r( abs(r(:,1) - r(:,2) ) > 1000 , :);

%Compute the means and differences of point pairs
rda = rDiffAve( [ d( r(:,1) , 1:2 ) d(r(:,2), 1:2)]);

%Look for points that are close together
smallDiff = rda( rda(:,3) < 0.05,:);

%Find the center of mass of that distribution
center = [mean(smallDiff(:,1)), mean(smallDiff(:,2)), 0];

%Pretty plot, if you want it.
figure(1)
plot( d(:,1), d(:,2),'.', smallDiff(:,1), smallDiff(:,2),'+', center(:,1), center(:,2) ,'*')

%center is now found.

%find all points within InnerPointDistance of the center
InnerPointDistance = 0.5;
InnerPointIndex = sqrt( (d(:,1)-center(1)).^2 + (d(:,2) - center(2)).^2 )  < InnerPointDistance;
InnerPoints = d(InnerPointIndex,:)-repmat(center,length(d(InnerPointIndex,:)),1);

%Scan vertically to find flexure center
%Find differences too (premature optimization is the devil, but I did it anyway)
%Muahahaha.

%scan by slicing
sliceSpacing = 0.01; %sets size of slices
sliceCenters = [];   %initializes an accumulator for slices

%Go slicing!
for y = -1:sliceSpacing:1

	%slice
	slice = InnerPoints( abs( InnerPoints(:,2) - y ) < sliceSpacing/2, :);

	%if there are enough points to make std() (barely) reasonable
	if( length(slice) > 4 )

		%find the center
		sliceCenter = mean(slice(:,1));

		%points to left and right of center define the two
		%edges of the flexure
		leftPoints  = slice( slice(:,1) < sliceCenter ,1 );
		rightPoints = slice( slice(:,1) > sliceCenter ,1 );

		%Mean left and right edges
		leftm  = mean( leftPoints );
		rightm = mean( rightPoints );

		%Uncertainties on each mean, assuming normal distribution
		lefterr  = std(leftPoints) /sqrt(length(leftPoints ));
		righterr = std(rightPoints)/sqrt(length(rightPoints));

		%add errors in quadrature
		diffErr = sqrt(lefterr^2 + righterr^2);

		%store it!
		sliceCenters = [sliceCenters; sliceCenter y rightm-leftm diffErr];
	end
end

%pretty plot #1
figure(2)
plot( d(:,1), d(:,2),'.', smallDiff(:,1), smallDiff(:,2),'+', sliceCenters(:,1), sliceCenters(:,2) ,'*')

%money plot.
figure(3)
errorbar(sliceCenters(:,2), sliceCenters(:,3), sliceCenters(:,4))
