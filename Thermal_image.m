tic;
clear all;
close all;

% Constants
last_temp = 30;
room_temp = 25;

%% Acquire Data
% Import data
pixel_section_vector = 0;
Avg_temp_vector = 0;
Data = importdata('Image.csv');
[m, n] = size(Data);
x = 1:n;
y = 1:m;
[X, Y] = meshgrid(x, y);
BW = edge(Data, 'Canny');

% Calculate pixel_section, pixel_start, and pixel_stop
for jj = 1:1:length(y)
    pixel_section_vector(jj) = mean(BW(jj, :));
end
pixel_section = find(pixel_section_vector(:) > 0.15);
pixel_start = pixel_section(1);
pixel_stop = pixel_section(end - 1);

% Find the average value of the top 20% temperature
percentage = 0.05;
percent_to_number = round(percentage * length(x));
counter = 1;
for jj = pixel_start:1:pixel_stop
    Ten_percent_temp = maxk(Data(jj, :), percent_to_number);
    Avg_temp_vector(2, counter) = mean(Ten_percent_temp);
    Avg_temp_vector(1, counter) = counter;
    counter = counter + 1;
end

% Pixels to distance
Avg_temp_vector(1, :) = flip(23 .* Avg_temp_vector(1, :));

figure('Name', 'Thermal Image')
imagesc(x, y, Data)
axis tight;
axis equal;
hold on;

% Mark Change line on thermal image
line([0, 320], [pixel_start, pixel_start], 'Color', 'r');
line([0, 320], [pixel_stop, pixel_stop], 'Color', 'r');
xlabel('$x \ pixels$', 'Interpreter', 'latex');
ylabel('$y \ pixels$', 'Interpreter', 'latex');
set(gca, 'fontsize', 16);
hcb = colorbar;
hcb.Title.String = 'Temperature (\circ C)';
hold on;

% Mark avg pixels
for jj = pixel_start:1:pixel_stop
    [pixel_mark, x_marker] = maxk(Data(jj, :), percent_to_number);
    y_marker = ones(1, length(x_marker)) .* jj;
    plot(x_marker, y_marker, 'r.', 'MarkerSize', 2);
end

% Save a thermal photo
saveas(gcf, 'Thermal Image.png');

%% Fitting Data
theta = (Avg_temp_vector(2, :) - room_temp) / (max(Avg_temp_vector(2, :)) - room_temp);
theta_old = (Avg_temp_vector(2, :) - room_temp) / (max(Avg_temp_vector(2, :)) - room_temp);
z = Avg_temp_vector(1, :) .* 10^-6;
z_old = Avg_temp_vector(1, :) .* 10^-6;
[xData, yData] = prepareCurveData(z, theta);

% Set up fittype and options
ft = fittype('(sqrt(h * A / 0.0015) * cosh(sqrt(h * A / 0.0015) * (0.0015 - x)) + h * sinh(sqrt(h * A / 0.0015) * (0.0015 - x)))  / (sqrt(h * A / 0.0015) * cosh(sqrt(h * A / 0.0015) * 0.0015) + h * sinh(sqrt(h * A / 0.0015) * 0.0015))', 'independent', 'x', 'dependent', 'y');
opts = fitoptions('Method', 'NonlinearLeastSquares');
opts.Lower = [0 0 0];
opts.Display = 'Off';
opts.Robust = 'Bisquare';
opts.StartPoint = [1 1];

% Fit model to data
[fitresult, gof] = fit(xData, yData, ft, opts);
coff = coeffvalues(fitresult);

figure('Name', 'Thermal Distribution')
plot(z, theta, 'o', 'LineWidth', 2);
hold on;
title(['Plate Temperature = ' num2str(max(Avg_temp_vector(2, :))) '(\circ C)']);
grid off;
set(gca, 'fontsize', 16);
hold on;
fit_result = plot(fitresult, '--');
xlabel('$z \ (m)$', 'Interpreter', 'latex');
ylabel('${\theta}$', 'Interpreter', 'latex');
ylim([0.8 1]);
xlim([0 2e-3]);
box on;
legend hide;
set(fit_result, 'LineWidth', 1.2);
saveas(gcf, 'Thermal Distribution.png');

fprintf('The A_h/A_k ratio is equal to: %.2e \n', coff(1));
fprintf('The h/k ratio is equal to: %.2e [1/m] \n', coff(2));

toc;
