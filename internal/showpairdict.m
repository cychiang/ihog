% showpairdict(pd, sy, sx)
%
% Visualizes a few random elements from the paired dictionaries 'pd'. The
% parameters sy and sx are optional and specify the number of elements to show.
function im = showpairdict(pd, sy, sx, random),

if ~exist('sy', 'var'),
  sy = 10;
end
if ~exist('sx', 'var'),
  sx = 10;
end
if ~exist('random', 'var'),
  random = 1;
end

hny = pd.ny;
hnx = pd.nx;
sbin = pd.sbin;

gny = (hny+2)*sbin;
gnx = (hnx+2)*sbin;

bord = 10;
cy = (gny+bord);
cx = (gnx*2+bord);

im = ones(cy*sy, cx*sx, 3);

if random,
  iii = randperm(size(pd.dgray,2));
else
  iii = 1:size(pd.dgray,2);
end

fprintf('ihog: show pair dict: ');
for i=1:min(sy*sx, pd.k),
  fprintf('.');

  row = mod(i-1, sx)+1;
  col = floor((i-1) / sx)+1;

  graypic = reshape(pd.dgray(:, iii(i)), [gny gnx 3]);
  graypic(:) = graypic(:) - min(graypic(:));
  graypic(:) = graypic(:) / max(graypic(:));

  hogfeat = reshape(pd.dhog(:, iii(i)), [hny hnx features]);
  hogpic = HOGpicture(hogfeat);
  hogpic = imresize(hogpic, [gny gnx]);
  hogpic(hogpic < 0) = 0;
  hogpic(hogpic > 1) = 1;
  hogpic = repmat(hogpic, [1 1 3]);

  pic = cat(2, graypic, hogpic);
  pic = padarray(pic, [bord bord], 1, 'post');

  im((col-1)*cy+1:col*cy, (row-1)*cx+1:row*cx, :) = pic;
end
fprintf('\n');

im = im(1:end-bord, 1:end-bord, :);

imagesc(im);
axis image;
