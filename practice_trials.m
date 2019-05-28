% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function exit_flag = practice_trials(initialization_struct, trials, block)

% 1 - Initial setup
format shortg
exit_flag = 0;

% ---- file set up; enables flexibility between OSX and Windows
sl = initialization_struct.slash_convention;

% ---- test or not?
test = initialization_struct.test;
input_source = initialization_struct.input_source;

% ---- shuffle the rng and save the seed
rng('shuffle');
rng_seed = rng;
rng_seed = rng_seed.Seed;

% ---- Screen setup
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
if test == 0
    HideCursor;
end
PsychDefaultSetup(1);

% ---- Screen selection
screens = Screen('Screens'); %count the screen
whichScreen = max(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
if test == 0
    [w, rect] = Screen('OpenWindow', whichScreen);
else
    % [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1440 810]); % for opening into a small rectangle instead
    [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1920 1080]); % for opening into a small rectangle instead
end

% --- font sizes
textsize = initialization_struct.textsize;
textsize_feedback = initialization_struct.textsize_feedback;
textsize_tickets = initialization_struct.textsize_tickets;

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 2 - Define image locations and stimuli used across blocks

% ---- display coordinates setup
r = [0,0,800,600]; %stimuli rectangle
r_small = [0,0,600,400]; % smaller rect for stimuli and rewards
rc_small = [0,0,600,425];
r_space = [0,0,1920,1080];
r_ship = [0,0,400,290];
r_tick_text = [0,0,300,150];
rects = cell(2,2); % rectangles for touchscreen

% ---- backgrounds
space_bg = CenterRectOnPoint(r_space, rect(3)*0.5, rect(4)*0.5);
spaceship_out = CenterRectOnPoint(r_ship, rect(3)*0.38, rect(4)*0.4);
spaceship_return = CenterRectOnPoint(r_ship, rect(3)*0.2, rect(4)*0.4);

% ---- locations on the win screen
alien_win = CenterRectOnPoint(r_small, rect(3)*.3, rect(4)*0.5);
treasure_win = CenterRectOnPoint(r_small, rect(3)*.7, rect(4)*0.5);
alien_lose = CenterRectOnPoint(r_small, rect(3)*.5, rect(4)*0.5);

% ---- define touchscreen rectangles to click (top/bottom)
rects{2,1} = [rect(3)*0.75 - rc_small(3)/2, rect(4)*0.25 - rc_small(4)/2, rect(3)*0.75 + rc_small(3)/2, rect(4)*0.25 + rc_small(4)/2];
rects{2,2} = [rect(3)*0.75 - rc_small(3)/2, rect(4)*0.75 - rc_small(4)/2, rect(3)*0.75 + rc_small(3)/2, rect(4)*0.75 + rc_small(4)/2];

% ---- location of the aliens
alien_Lpoint = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.5);
alien_Rpoint = CenterRectOnPoint(r, rect(3)*0.75, rect(4)*0.5);

% ---- frames - white during every trial; green when chosen
alien_Lframe = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.5);
alien_Rframe = CenterRectOnPoint(r, rect(3)*0.75, rect(4)*0.5);

% ---- define touchscreen rectangles to click (left/right)
rects{1,1} = [rect(3)*0.25 - r(3)/2, rect(4)*0.5 - r(4)/2, rect(3)*0.25 + r(3)/2, rect(4)*0.5 + r(4)/2];
rects{1,2} = [rect(3)*0.75 - r(3)/2, rect(4)*0.5 - r(4)/2, rect(3)*0.75 + r(3)/2, rect(4)*0.5 + r(4)/2];

% ---- read/draw the treasure
treasure = imread(['stimuli' sl 'treasure.png'],'png');
treasure_spent = imread(['stimuli' sl 'treasure_spent.png'],'png');
earth = imread(['stimuli' sl 'earth.png'],'png');
return_home = imread(['stimuli' sl 'return_home.png'],'png');

treasure = Screen('MakeTexture', w, treasure);
treasure_spent = Screen('MakeTexture', w, treasure_spent);
earth = Screen('MakeTexture', w, earth);
return_home = Screen('MakeTexture', w, return_home);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% --- spaceships
A1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(1)) sl 'docked.png'],'png');
B1 = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(2)) sl 'docked.png'],'png');

A1_out = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(1)) sl 'out.png'],'png');
A1_return = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(1)) sl 'return.png'],'png');

B1_out = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(2)) sl 'out.png'],'png');
B1_return = imread(['stimuli' sl 'spaceships' sl char(initialization_struct.stim_color_step1(1)) sl ...
   char(initialization_struct.spaceships(2)) sl 'return.png'],'png');

% ---- aliens
A2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
  char(initialization_struct.aliens(1)) '.png'],'png');
B2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl ...
  char(initialization_struct.aliens(2)) '.png'],'png');

A3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
  char(initialization_struct.aliens(3)) '.png'],'png');
B3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl ...
  char(initialization_struct.aliens(4)) '.png'],'png');

  % read and draw background stimuli
  space = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl 'space.png'],'png');
  planet_home = imread(['stimuli' sl 'home_planet.png'],'png');
  planet_2 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(1)) sl 'planet.png'],'png');
  planet_3 = imread(['stimuli' sl 'aliens' sl char(initialization_struct.stim_colors_step2(1)) sl char(initialization_struct.stim_step2_color_select(2)) sl 'planet.png'],'png');

  space = Screen('MakeTexture', w, space);
  planet_home = Screen('MakeTexture', w, planet_home);
  planet_2 = Screen('MakeTexture', w, planet_2);
  planet_3 = Screen('MakeTexture', w, planet_3);
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 6 - Additional set up
% ---- Keyboard
KbName('UnifyKeyNames');
L = KbName('LeftArrow');
R = KbName('RightArrow');
U = KbName('UpArrow');
D = KbName('DownArrow');

% ---- Transition variables
a = 0.4 + 0.6.*rand(trials,2); %transition probabilities
r = rand(trials, 2); %transition determinant

% ---- Colors
black = 0;
white = [253 252 250];
chosen_color = [0 220 0];
frame_color = white;

% ---- formatting for loading bar
hor_align = rect(3)*0.5;
ver_align = rect(4)*0.55;
rate_obj = robotics.Rate(24);

% ---- blank matrices for variables
action = NaN(trials,4);
click_coord = NaN(trials, 8);
choice_on_time = NaN(trials,4);
choice_off_time = NaN(trials,4);
choice_on_datetime = cell(trials,4);
choice_off_datetime = cell(trials,4);
position = NaN(trials,4);
state = NaN(trials,1);
iti_start = NaN(trials,1);

payoff_det = rand(trials,4);
payoff = NaN(trials,2);

iti_selected = zeros(trials, 1);
iti_actual = zeros(trials, 1);
condition = initialization_struct.condition;

% ---- Waiting screen
Screen('FillRect', w, black);
Screen('TextSize', w, textsize);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 7 - Task intro screens
% ---- Intro screen for practice block
DrawFormattedText(w,[
    'Let''s practice!' '\n\n' ...
    'When you are ready, the experimenter will start the training quest.' '\n' ...
    'You will have 10 days to explore this galaxy.'....
    ], 'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
task_func.advance_screen(input_source)
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 8 - Begin trials
t0 = GetSecs;
for trial = 1:trials

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.1 - Stage 1
% ---- Signal a short break every 50 trials on blocks 1,2
    % ---- Drawimage indicators
    Screen(w, 'FillRect', black);
    Screen('TextSize', w, textsize_feedback);
    position(trial,1) = round(rand); %randomizing images positions
    type = position(trial,1);

    % ---- Draw original stimuli using a function that Arkady wrote: drawimage
    picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3,type,1);
    picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3,1-type,1);

    % ---- Draw trial screen
    % draw background
    Screen('DrawTexture', w, planet_home, [], space_bg);
    % draw original stimuli
    Screen('DrawTexture', w, picL, [], alien_Lpoint);
    Screen('DrawTexture', w, picR, [], alien_Rpoint);
    % draw frames around original stimuli
    Screen('FrameRect',w,frame_color,alien_Lframe,10);
    Screen('FrameRect',w,frame_color,alien_Rframe,10);
    Screen('Flip', w);

    % ---- start reaction timer
    choice_on_time(trial,1) = GetSecs - t0;
    choice_on_datetime{trial,1} = clock;

    % ---- capture key press
    [selection, x, y] = task_func.selection(input_source, [L,R], w, rects);
    click_coord(trial, 1) = x;
    click_coord(trial, 2) = y;

    % ---- stop reaction timer
    choice_off_time(trial,1) = GetSecs - t0;
    choice_off_datetime{trial,1} = clock;

    % ---- capture selection
    [action(trial,1), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

    % ---- feedback screen
    if choice_loc == L
        % draw background
        Screen('DrawTexture', w, planet_home, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,chosen_color,alien_Lframe,10);
        Screen('FrameRect',w,frame_color,alien_Rframe,10);
        Screen('Flip', w);

    elseif choice_loc == R
       % draw background
       Screen('DrawTexture', w, planet_home, [], space_bg);
       % draw original stimuli
       Screen('DrawTexture', w, picL, [], alien_Lpoint);
       Screen('DrawTexture', w, picR, [], alien_Rpoint);
       % draw frames around original stimuli
       Screen('FrameRect',w,frame_color,alien_Lframe,10);
       Screen('FrameRect',w,chosen_color,alien_Rframe,10);
       Screen('Flip', w);

    end

    % ---- wait 1 second on the feedback screen
    WaitSecs(1);

    % ---- space exploration page
    Screen('DrawTexture', w, space, [], space_bg);
    ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'out');
    Screen('DrawTexture', w, ship, [], spaceship_out);
    Screen('Flip', w);
    WaitSecs(1);


    % ---- Determine the state for the second state
    % ---- a ~ U[0.4,1]
    % ---- r ~ U[0,1]
    % ---- p(r < a) = 0.70
    % ---- p(r > a) = 0.30
    % ---- If we discretize the "a" distribution, remember that there is a 1/7
    % ---- chance of "a" taking the any value [0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]

    if action(trial,1) == 0
        if  r(trial, 1) < a(trial,1)
            state(trial,1) = 2;
        else state(trial,1) = 3;
        end
    else
        if  r(trial, 2) > a(trial,2)
            state(trial,1) = 2;
        else state(trial,1) = 3;
        end
    end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9.2A State 2

    if state(trial,1) == 2

    % ---- Randomize the left/right position of the original stimuli
        Screen(w, 'FillRect', black);
        position(trial,2) = round(rand);
        type = position(trial,2);

    % ---- Draw original stimuli using a function that Arkady wrote: drawimage
        picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, type,2);
        picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,2);

    % ---- Draw trial screen
        % draw background
        Screen('DrawTexture', w, planet_2, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,white,alien_Lframe,10);
        Screen('FrameRect',w,white,alien_Rframe,10);

        Screen('Flip', w);

    % ---- start reaction timer
        choice_on_time(trial,2) = GetSecs - t0;
        choice_on_datetime{trial,2} = clock;

    % ---- capture key press
        [selection, x, y] = task_func.selection(input_source, [L,R], w, rects);
        click_coord(trial, 3) = x;
        click_coord(trial, 4) = y;

    % ---- stop reaction timer
        choice_off_time(trial,2) = GetSecs - t0;
        choice_off_datetime{trial,2} = clock;

    % ---- capture selection and determine payoff
        [action(trial,2), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

        if action(trial,2) == 0
            if payoff_det(trial, 1) <  initialization_struct.payoff_prob(trial,1)
                payoff(trial,1) = 1;
            else
                payoff(trial,1) = 0;
            end
        elseif action(trial,2) == 1
            if payoff_det(trial, 2) <  initialization_struct.payoff_prob(trial,2)
                payoff(trial,1) = 1;
            else
                payoff(trial,1) = 0;
            end
        end

    % ---- feedback screen
        if choice_loc == L
          % draw background
          Screen('DrawTexture', w, planet_2, [], space_bg);
          % draw original stimuli
          Screen('DrawTexture', w, picL, [], alien_Lpoint);
          Screen('DrawTexture', w, picR, [], alien_Rpoint);
          % draw frames around original stimuli
          Screen('FrameRect',w,chosen_color,alien_Lframe,10);
          Screen('FrameRect',w,white,alien_Rframe,10);
          Screen('Flip', w);
          % wait 1 second
          WaitSecs(1);

       elseif choice_loc == R
          % draw background
          Screen('DrawTexture', w, planet_2, [], space_bg);
          % draw original stimuli
          Screen('DrawTexture', w, picL, [], alien_Lpoint);
          Screen('DrawTexture', w, picR, [], alien_Rpoint);
          % draw frames around original stimuli
          Screen('FrameRect',w,white,alien_Lframe,10);
          Screen('FrameRect',w,chosen_color,alien_Rframe,10);
          Screen('Flip', w);
          % wait 1 second
          WaitSecs(1);
        end

        % ---- payoff screen
        % ---- show feedback
        picD = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,2),2);
        if payoff(trial,1) == 1
            Screen('DrawTexture', w, picD, [], alien_win);
            Screen('DrawTexture', w, treasure, [], treasure_win);
            DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
        else
            Screen('DrawTexture', w, picD, [], alien_lose);
            DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
        end
        Screen('Flip', w);
        WaitSecs(1);

        % variable text that will change on the last trial of the game
        Screen('TextSize', w, textsize);
        iti_start(trial) = GetSecs - t0;

        % countdown to next trial
        for i = 1:initialization_struct.iti_init(trial, payoff(trial,1)+3)
            % ---- space exploration page
            Screen('DrawTexture', w, return_home, [], space_bg);
            ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'return');
            Screen('DrawTexture', w, ship, [], spaceship_return);

            % countdown text
            DrawFormattedText(w, [
                'Returning Home...' ...
                ], 'center', 'center', white, [], [], [], 1.6);

            % load bar fill calculation
            fill_width = initialization_struct.iti_init(trial, nansum(payoff(trial,:))+5) * i;

            % fill for the load bar
            Screen('FillRect',w, [255 255 255], ...
            CenterRectOnPoint([0,0,fill_width, initialization_struct.load_bar_dimensions(2)], hor_align - initialization_struct.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

           % outline for the load bar
            Screen('FrameRect',w, [255 255 255], ...
            CenterRectOnPoint([0,0,initialization_struct.load_bar_dimensions(1),initialization_struct.load_bar_dimensions(2)], hor_align, ver_align), 3);

           Screen(w, 'Flip');
           waitfor(rate_obj);
        end

        iti_actual(trial) = GetSecs - t0 - iti_start(trial);
        iti_selected(trial) = initialization_struct.iti_init(trial, payoff(trial,1)+1);


    % -----------------------------------------------------------------------------
    % -----------------------------------------------------------------------------
    % -----------------------------------------------------------------------------
    % -----------------------------------------------------------------------------
    % 9.2B State 3
    else

    % Randomize the left/right position of the original stimuli
        Screen(w, 'FillRect', black);
        position(trial,3) = round(rand);
        type = position(trial,3);

    % ---- Draw original stimuli using a function that Arkady wrote: drawimage
        picL = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, type,3);
        picR = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, 1-type,3);

    % ---- Draw trial screen
        % draw background
        Screen('DrawTexture', w, planet_3, [], space_bg);
        % draw original stimuli
        Screen('DrawTexture', w, picL, [], alien_Lpoint);
        Screen('DrawTexture', w, picR, [], alien_Rpoint);
        % draw frames around original stimuli
        Screen('FrameRect',w,white,alien_Lframe,10);
        Screen('FrameRect',w,white,alien_Rframe,10);

        Screen('Flip', w);

    % ---- start reaction timer
        choice_on_time(trial,3) = GetSecs - t0;
        choice_on_datetime{trial,3} = clock;

    % ---- capture key press
        [selection, x, y] = task_func.selection(input_source, [L,R], w, rects);
        click_coord(trial, 5) = x;
        click_coord(trial, 6) = y;

    % ---- stop reaction timer
        choice_off_time(trial,3) = GetSecs - t0;
        choice_off_datetime{trial,3} = clock;

    % ---- capture selection and determine payoff
        [action(trial,3), choice_loc] = task_func.choice(type, [L,R], selection, x, y);

        if action(trial,3) == 0
            if payoff_det(trial, 3) <  initialization_struct.payoff_prob(trial,3)
                payoff(trial,2) = 1;
            else
                payoff(trial,2) = 0;
            end
        elseif action(trial,3) == 1
            if payoff_det(trial, 4) <  initialization_struct.payoff_prob(trial,4)
                payoff(trial,2) = 1;
            else
                payoff(trial,2) = 0;
            end
        end

    % ---- feedback screen
        if choice_loc == L
          % draw background
          Screen('DrawTexture', w, planet_3, [], space_bg);
          % draw original stimuli
          Screen('DrawTexture', w, picL, [], alien_Lpoint);
          Screen('DrawTexture', w, picR, [], alien_Rpoint);
          % draw frames around original stimuli
          Screen('FrameRect',w,chosen_color,alien_Lframe,10);
          Screen('FrameRect',w,white,alien_Rframe,10);
          Screen('Flip', w);
          % wait 1 second
          WaitSecs(1);

        elseif choice_loc == R
          % draw background
          Screen('DrawTexture', w, planet_3, [], space_bg);
          % draw original stimuli
          Screen('DrawTexture', w, picL, [], alien_Lpoint);
          Screen('DrawTexture', w, picR, [], alien_Rpoint);
          % draw frames around original stimuli
          Screen('FrameRect',w,white,alien_Lframe,10);
          Screen('FrameRect',w,chosen_color,alien_Rframe,10);
          Screen('Flip', w);
          % wait 1 second
          WaitSecs(1);
        end

    % ---- payoff screen
    % ---- determine second step choice
        picD = task_func.drawimage(w, A1, B1, A2, B2, A3, B3, action(trial,3),3);
        if payoff(trial,2) == 1
            Screen('DrawTexture', w, picD, [], alien_win);
            Screen('DrawTexture', w, treasure, [], treasure_win);
            DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
        else
            Screen('DrawTexture', w, picD, [], alien_lose);
            DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
        end
        Screen('Flip', w);
        WaitSecs(1);

        % variable text that will change based on their reward choice and trial
        Screen('TextSize', w, textsize);
        iti_start(trial) = GetSecs - t0;
        % countdown to next trial
        for i = 1:initialization_struct.iti_init(trial, payoff(trial,2)+3)
            % ---- space exploration page
            Screen('DrawTexture', w, return_home, [], space_bg);
            ship = task_func.drawspaceship(w, A1_out, A1_return, B1_out, B1_return, action(trial,1), 'return');
            Screen('DrawTexture', w, ship, [], spaceship_return);

            % countdown text
            DrawFormattedText(w, [
                'Returning Home....' ...
                ], 'center', 'center', white, [], [], [], 1.6);

            % load bar fill calculation
            fill_width = initialization_struct.iti_init(trial, nansum(payoff(trial,:))+5) * i;

            % fill for the load bar
            Screen('FillRect',w, [255 255 255], ...
            CenterRectOnPoint([0,0,fill_width, initialization_struct.load_bar_dimensions(2)], hor_align - initialization_struct.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

           % outline for the load bar
            Screen('FrameRect',w, [255 255 255], ...
            CenterRectOnPoint([0,0,initialization_struct.load_bar_dimensions(1),initialization_struct.load_bar_dimensions(2)], hor_align, ver_align), 3);

           Screen(w, 'Flip');
           waitfor(rate_obj);
        end

        iti_actual(trial) = GetSecs - t0 - iti_start(trial);
        iti_selected(trial) = initialization_struct.iti_init(trial, payoff(trial,2)+1);
    end % close the if/else for state
end % close the entire for loop
RestrictKeysForKbCheck([]);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9 - Saving data
practice_struct = struct;
practice_struct.rng_seed = rng_seed; % save the rng seed set at the top of the script
practice_struct.subject = initialization_struct.sub;
practice_struct.stim_color_step1 = initialization_struct.stim_color_step1(block+1); % stimuli are always selected where 1st item in array goes to practice, then money, then food
practice_struct.stim_colors_step2 = initialization_struct.stim_colors_step2(block+1);
practice_struct.position = position;
practice_struct.action = action;
practice_struct.click_coord = click_coord;
practice_struct.on = choice_on_time;
practice_struct.off = choice_off_time;

practice_struct.on_datetime = choice_on_datetime;
practice_struct.off_datetime = choice_off_datetime;

practice_struct.rt = choice_off_time-choice_on_time;
practice_struct.iti_start = iti_start;
practice_struct.iti_actual = iti_actual;
practice_struct.iti_selected = iti_selected;
practice_struct.transition_prob = a;
practice_struct.transition_det = r;
practice_struct.payoff_det = payoff_det;
practice_struct.payoff = payoff;
practice_struct.state = state;

% ---- unique to this block
practice_struct.block = find(initialization_struct.block == 0);
practice_struct.spaceships = initialization_struct.spaceships(1:2);
practice_struct.aliens = initialization_struct.aliens(1:4);
save([initialization_struct.data_file_path sl 'practice'], 'practice_struct', '-v6');

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% 9 - Payoff screens
% ---- Practice block end screens
Screen('TextSize', w, textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'Congratulations Space Captain, you are done the training quest!' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(1);;
task_func.advance_screen(input_source);

Screen('TextSize', w, textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'You have finished training camp and are ready to win prizes on your big quest.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(1);;
task_func.advance_screen(input_source);

Screen('TextSize', w, textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'When you are ready, ' initialization_struct.researcher ' will load the directions for winning prizes.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(1);;
task_func.advance_screen(input_source);

ShowCursor;
Screen('CloseAll');
FlushEvents;

end