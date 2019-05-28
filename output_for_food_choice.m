% This code is designed to compile the necessary information for the video coding
% application. It pulls from each of the MatLab structures to create an excel file
% that is used as an input to make coding of food choice easier.

% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function output_for_food_choice(init)
    sl = init.slash_convention;

    % load all of the necessary structures
    load([init.data_file_path sl 'task.mat']);

    % number of trials/size of the array
    trials = init.num_trials(2);
    df = cell(trials, 9);
    df(:, 1) = num2cell(init.sub);
    df(:, 2) = cellstr(init.researcher);
    df(:, 3) = cellstr(init.condition);
    df(:, 4) = cellstr(init.left_item);
    df(:, 5) = cellstr(init.right_item);
    df(:,6) = num2cell(1:trials);
    df(:,7) = num2cell(nansum(task.payoff, 2));
    df(:,8) = num2cell((task.action(:,4) - 1)*-1);

    % convert array to table
    T = table(df(:,1), df(:,2), df(:,3), df(:,4), df(:,5), df(:,6), df(:,7), df(:,8), df(:,9), ...
    'VariableNames', {'subject', 'researcher', 'condition', 'left_item', 'right_item', 'trial', 'win', 'choose_snack_stick', 'choose_left'});

    % print table to excel
    writetable(T, [init.data_file_path sl 'food_choice.xlsx']);
end
