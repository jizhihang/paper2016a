function pos_img = my_showboxes(im, boxes, partcolor)
% I sligthly modified this function

%imagesc(im); axis image; axis off;
if ~isempty(boxes)
  numparts = length(partcolor);
  pos_img = zeros(2,numparts); % Added by Joha. Using PARSE_eval_apk
  
  box = boxes(:,1:4*numparts);
  xy = reshape(box,size(box,1),4,numparts);
  xy = permute(xy,[1 3 2]);
	x1 = xy(:,:,1);
	y1 = xy(:,:,2);
	x2 = xy(:,:,3);
	y2 = xy(:,:,4);
    bx = .5*xy(:,:,1) + .5*xy(:,:,3);% Added by Joha
    by = .5*xy(:,:,2) + .5*xy(:,:,4);% Added by Joha
	for p = 1:size(xy,2)
		%line([x1(:,p) x1(:,p) x2(:,p) x2(:,p) x1(:,p)]',[y1(:,p) y2(:,p) y2(:,p) y1(:,p) y1(:,p)]',...
		%'color',partcolor{p},'linewidth',2);
    pos_img(1,p) = bx(p);
    pos_img(2,p) = by(p);
   % hold on
   % plot(bx(p),by(p),'r.','MarkerSize',20);
	end
end
%drawnow;
