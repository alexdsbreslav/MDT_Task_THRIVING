% Please do not share or use this code without my written permission.
% Author: Alex Breslav

function exit_flag = tutorial_part1(init)

% ---- Initial set up
% capture screenshots
img_idx = 100;

% sets the exit flag default to 0; throws a flag if you exit the function to leave the start function
exit_flag = 0;

% file set up; enables flexibility between OSX and Windows
sl = init.slash_convention;

% ---- psychtoolbox set up
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel', 1);% change psych toolbox screen check to black
FlushEvents;
HideCursor;
PsychDefaultSetup(1);

% ---- stimuli set up
% Need to define the color name
if strcmp(char(init.stim_color_step1(1)), 'blue') == 1
    step1_color = 'blue';
else
    step1_color = 'orange';
end

if strcmp(char(init.stim_step2_color_select(1)), 'warm') == 1
    if strcmp(char(init.stim_colors_step2(1)), 'red_purple') == 1
        state2_color = 'red';
        state2_name = 'Rigel';
        state3_color = 'purple';
        state3_name = 'Pentarus';
    else
        state2_color = 'yellow';
        state2_name = 'Yadera';
        state3_color = 'green';
        state3_name = 'Gaspar';
    end
else
    if strcmp(char(init.stim_colors_step2(1)), 'red_purple') == 1
        state2_color = 'purple';
        state2_name = 'Pentarus';
        state3_color = 'red';
        state3_name = 'Rigel';
    else
        state2_color = 'green';
        state2_name = 'Gaspar';
        state3_color = 'yellow';
        state3_name = 'Yadera';
    end
end

% ---- Screen selection
screens = Screen('Screens'); %count the screen
whichScreen = max(screens); %select the screen; ALTERED THIS BECAUSE IT KEPT SHOWING UP ON MY LAPTOP INSTEAD OF THE ATTACHED MONITOR
if init.test == 0
    [w, rect] = Screen('OpenWindow', whichScreen);
else
    % [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1440 810]); % for opening into a small rectangle instead
    [w, rect] = Screen('OpenWindow', whichScreen, [], [0 0 1920 1080]); % for opening into a small rectangle instead
end

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
r_txt_bg = [0,0,1550,75];
rects = cell(2,2); % rectangles for touchscreen

% ---- tutorial locations
center_above_text = CenterRectOnPoint(r_small, rect(3)*0.5, rect(4)*0.4);
four_aliens = {CenterRectOnPoint(r_ship, rect(3)*0.125, rect(4)*0.3),
            CenterRectOnPoint(r_ship, rect(3)*0.375, rect(4)*0.3),
            CenterRectOnPoint(r_ship, rect(3)*0.625, rect(4)*0.3),
            CenterRectOnPoint(r_ship, rect(3)*0.875, rect(4)*0.3)};
caves = {CenterRectOnPoint(r_ship, rect(3)*0.125, rect(4)*0.5),
            CenterRectOnPoint(r_ship, rect(3)*0.375, rect(4)*0.5),
            CenterRectOnPoint(r_ship, rect(3)*0.625, rect(4)*0.5),
            CenterRectOnPoint(r_ship, rect(3)*0.875, rect(4)*0.5)};
txt_bg = CenterRectOnPoint(r_txt_bg, rect(3)*0.5, rect(4)*0.9);
txt_bg_center = CenterRectOnPoint(r_txt_bg, rect(3)*0.5, rect(4)*0.5);
mines = CenterRectOnPoint([0,0,1000,725], rect(3)*0.7, rect(4)*0.4);
alien_miner = CenterRectOnPoint(r, rect(3)*0.25, rect(4)*0.45);

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

% read/draw the mining images
cave = imread(['stimuli' sl 'tutorial' sl 'cave.png'],'png');
mines_poor = imread(['stimuli' sl 'tutorial' sl 'mines_poor.png'],'png');
mines_poor_exc = imread(['stimuli' sl 'tutorial' sl 'mines_poor_exc.png'],'png');
mines_rich = imread(['stimuli' sl 'tutorial' sl 'mines_rich.png'],'png');
mines_rich_exc = imread(['stimuli' sl 'tutorial' sl 'mines_rich_exc.png'],'png');

cave = Screen('MakeTexture', w, cave);
mines_poor = Screen('MakeTexture', w, mines_poor);
mines_poor_exc = Screen('MakeTexture', w, mines_poor_exc);
mines_rich = Screen('MakeTexture', w, mines_rich);
mines_rich_exc = Screen('MakeTexture', w, mines_rich_exc);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% --- spaceships
A1 = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'docked.png'],'png');
B1 = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'docked.png'],'png');

A1_out = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'out.png'],'png');
A1_return = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(1)) sl 'return.png'],'png');

B1_out = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'out.png'],'png');
B1_return = imread(['stimuli' sl 'spaceships' sl char(init.stim_color_step1(1)) sl ...
   char(init.spaceships(2)) sl 'return.png'],'png');

A1 = Screen('MakeTexture', w, A1);
B1 = Screen('MakeTexture', w, B1);
A1_out = Screen('MakeTexture', w, A1_out);
A1_return = Screen('MakeTexture', w, A1_return);
B1_out = Screen('MakeTexture', w, B1_out);
B1_return = Screen('MakeTexture', w, B1_return);

% ---- aliens
A2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl ...
  char(init.aliens(1)) '.png'],'png');
B2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl ...
  char(init.aliens(2)) '.png'],'png');

A3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl ...
  char(init.aliens(3)) '.png'],'png');
B3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl ...
  char(init.aliens(4)) '.png'],'png');

A2 = Screen('MakeTexture', w, A2);
B2 = Screen('MakeTexture', w, B2);
A3 = Screen('MakeTexture', w, A3);
B3 = Screen('MakeTexture', w, B3);

% read and draw background stimuli
space = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl 'space.png'],'png');
planet_home = imread(['stimuli' sl 'home_planet.png'],'png');
planet_2 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(1)) sl 'planet.png'],'png');
planet_3 = imread(['stimuli' sl 'aliens' sl char(init.stim_colors_step2(1)) sl char(init.stim_step2_color_select(2)) sl 'planet.png'],'png');

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

% ---- Colors
black = 0;
white = [253 252 250];
chosen_color = [0 220 0];
frame_color = white;

% ---- formatting for loading bar
hor_align = rect(3)*0.5;
ver_align = rect(4)*0.55;
rate_obj = robotics.Rate(24);

% --- keep track of actions
action = NaN(2,3);

% ---- Waiting screen
Screen('FillRect', w, black);
Screen('TextSize', w, init.textsize);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% ---- slide 1
DrawFormattedText(w,[
    'Welcome to training camp, Space Captain!' '\n\n' ...
    'We are going to work together with ' init.researcher '\n' ...
    'to learn how to play the game. Make sure to listen carefully!' ...
    ], 'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 2
Screen('DrawTexture', w, treasure, [], center_above_text);
DrawFormattedText(w,[
    'In this game, you are trying to find space treasure.' ...
    ],'center', rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 3
Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'These aliens each have their own cave where they dig for space treasure.' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 4
Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'The goal of the game is to find the alien that has the most space treasure to share.' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 5
Screen('DrawTexture', w, space, [], space_bg);
Screen('FillRect', w, black, txt_bg_center);
DrawFormattedText(w,[
     'These aliens live in a galaxy on far away planets.' ...
     ],'center', 'center', white, [], [], [], 1.6, [], txt_bg_center);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 6
Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'The ' state2_color ' aliens live on Planet ' state2_name '.'...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 7
Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'The ' state3_color ' aliens live on Planet ' state3_name '.'...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 7
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'To get to these far away planets, we have given you two spaceships.'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 8
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Each day, you will pick one spaceship to explore the galaxy.'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% ---- slide 9
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s start off by choosing the spaceship on the left.'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% ---- slide 10
% capture choice 1.1
[selection, x, y] = task_func.selection(init.input_source, [L], w, rects);
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,chosen_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
WaitSecs(init.feedback_time);

% space exploration page
Screen('DrawTexture', w, space, [], space_bg);
Screen('DrawTexture', w, A1_out, [], spaceship_out);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Your spaceship will navigate the galaxy and choose a planet to land on.'
    ],'center', 'center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Today, your spaceship landed on ' state2_name ', home to the ' state2_color ' aliens!'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now we will ask one alien if they have space treasure to share.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'We can only ask one alien to share their space treasure each day.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s ask the alien on the right if they have space treasure to share!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% capture choice 1.2
[selection, x, y] = task_func.selection(init.input_source, [R], w, rects);
Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,chosen_color,alien_Rframe,10);
Screen('Flip', w);
WaitSecs(init.feedback_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

Screen('DrawTexture', w, B2, [], alien_win);
Screen('DrawTexture', w, treasure, [], treasure_win);
DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Nice Job! You chose an alien who had space treasure to share!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, B2, [], alien_win);
Screen('DrawTexture', w, treasure, [], treasure_win);
DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s return home so we can try again!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% countdown to next trial
for i = 1:50
    % ---- space exploration page
    Screen('DrawTexture', w, return_home, [], space_bg);
    Screen('DrawTexture', w, A1_return, [], spaceship_return);

    % countdown text
    DrawFormattedText(w, [
        'Returning Home...' ...
        ], 'center', 'center', white, [], [], [], 1.6);

    % load bar fill calculation
    fill_width = 8*i;

    % fill for the load bar
    Screen('FillRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,fill_width, init.load_bar_dimensions(2)], hor_align - init.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

   % outline for the load bar
    Screen('FrameRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,init.load_bar_dimensions(1),init.load_bar_dimensions(2)], hor_align, ver_align), 3);

   Screen(w, 'Flip');

   if i == 25;
      img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
   end
   waitfor(rate_obj);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Walk through #2
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now let''s choose the spaceship on the right.'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% capture choice 2.1
[selection, x, y] = task_func.selection(init.input_source, [R], w, rects);
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,chosen_color,alien_Rframe,10);
Screen('Flip', w);
WaitSecs(init.feedback_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% space exploration page
Screen('DrawTexture', w, space, [], space_bg);
Screen('DrawTexture', w, B1_out, [], spaceship_out);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Your spaceship is navigating the galaxy and will land shortly...'
    ],'center', 'center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Today, your spaceship landed on ' state3_name ', home to the ' state3_color ' aliens!'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now we will ask one alien if they have space treasure to share.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'We can only ask one alien to share their space treasure each day.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s ask the alien on the right if they have space treasure to share!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

% capture choice 2.2
[selection, x, y] = task_func.selection(init.input_source, [R], w, rects);
Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,chosen_color,alien_Rframe,10);
Screen('Flip', w);
WaitSecs(init.feedback_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

Screen('DrawTexture', w, B3, [], alien_lose);
DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Oh no! This alien didn''t have any space treasure to share today.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, B3, [], alien_lose);
DrawFormattedText(w, 'Lose', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s keep exploring to see if we can find more space treasure.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% countdown to next trial
for i = 1:50
    % ---- space exploration page
    Screen('DrawTexture', w, return_home, [], space_bg);
    Screen('DrawTexture', w, B1_return, [], spaceship_return);

    % countdown text
    DrawFormattedText(w, [
        'Returning Home...' ...
        ], 'center', 'center', white, [], [], [], 1.6);

    % load bar fill calculation
    fill_width = 8*i;

    % fill for the load bar
    Screen('FillRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,fill_width, init.load_bar_dimensions(2)], hor_align - init.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

   % outline for the load bar
    Screen('FrameRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,init.load_bar_dimensions(1),init.load_bar_dimensions(2)], hor_align, ver_align), 3);

   Screen(w, 'Flip');
   if i == 25
      img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
   end
   waitfor(rate_obj);
end
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Walk through #3
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now you choose which spaceship you want to explore the galaxy.'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

[selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);
type = 0;
[action(1,1), choice_loc] = task_func.choice(type, [L,R], selection, x, y);
% ---- feedback screen
if choice_loc == L
    % draw background
    Screen('DrawTexture', w, planet_home, [], space_bg);
    % draw original stimuli
    Screen('DrawTexture', w, A1, [], alien_Lpoint);
    Screen('DrawTexture', w, B1, [], alien_Rpoint);
    % draw frames around original stimuli
    Screen('FrameRect',w,chosen_color,alien_Lframe,10);
    Screen('FrameRect',w,frame_color,alien_Rframe,10);
    Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

elseif choice_loc == R
   % draw background
   Screen('DrawTexture', w, planet_home, [], space_bg);
   % draw original stimuli
   Screen('DrawTexture', w, A1, [], alien_Lpoint);
   Screen('DrawTexture', w, B1, [], alien_Rpoint);
   % draw frames around original stimuli
   Screen('FrameRect',w,frame_color,alien_Lframe,10);
   Screen('FrameRect',w,chosen_color,alien_Rframe,10);
   Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
end

% ---- wait 1 second on the feedback screen
WaitSecs(init.feedback_time);

% ---- space exploration page
Screen('DrawTexture', w, space, [], space_bg);
if choice_loc == L
    ship_out = A1_out;
    ship_return = A1_return;
elseif choice_loc == R
    ship_out = B1_out;
    ship_return = B1_return;
end
Screen('DrawTexture', w, ship_out, [], spaceship_out);
Screen('Flip', w);
WaitSecs(init.explore_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Today, your spaceship landed on ' state2_name ', home to the ' state2_color ' aliens!'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now you ask one alien if they have space treasure to share.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

[selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);
[action(1,2), choice_loc] = task_func.choice(type, [L,R], selection, x, y);
% ---- feedback screen
if choice_loc == L
    % draw background
    Screen('DrawTexture', w, planet_2, [], space_bg);
    % draw original stimuli
    Screen('DrawTexture', w, A2, [], alien_Lpoint);
    Screen('DrawTexture', w, B2, [], alien_Rpoint);
    % draw frames around original stimuli
    Screen('FrameRect',w,chosen_color,alien_Lframe,10);
    Screen('FrameRect',w,frame_color,alien_Rframe,10);
    Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

elseif choice_loc == R
   % draw background
   Screen('DrawTexture', w, planet_2, [], space_bg);
   % draw original stimuli
   Screen('DrawTexture', w, A2, [], alien_Lpoint);
   Screen('DrawTexture', w, B2, [], alien_Rpoint);
   % draw frames around original stimuli
   Screen('FrameRect',w,frame_color,alien_Lframe,10);
   Screen('FrameRect',w,chosen_color,alien_Rframe,10);
   Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
end
WaitSecs(init.feedback_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

if choice_loc == L
    Screen('DrawTexture', w, A2, [], alien_win);
elseif choice_loc == R
    Screen('DrawTexture', w, B2, [], alien_win);
end
Screen('DrawTexture', w, treasure, [], treasure_win);
DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Nice Job! You chose an alien who had space treasure to share!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

if choice_loc == L
    Screen('DrawTexture', w, A2, [], alien_win);
elseif choice_loc == R
    Screen('DrawTexture', w, B2, [], alien_win);
end
Screen('DrawTexture', w, treasure, [], treasure_win);
DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Let''s return home so we can try one more time.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% countdown to next trial
for i = 1:50
    % ---- space exploration page
    Screen('DrawTexture', w, return_home, [], space_bg);
    Screen('DrawTexture', w, ship_return, [], spaceship_return);

    % countdown text
    DrawFormattedText(w, [
        'Returning Home...' ...
        ], 'center', 'center', white, [], [], [], 1.6);

    % load bar fill calculation
    fill_width = 8*i;

    % fill for the load bar
    Screen('FillRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,fill_width, init.load_bar_dimensions(2)], hor_align - init.load_bar_dimensions(1)/2 + fill_width/2, ver_align));

   % outline for the load bar
    Screen('FrameRect',w, [255 255 255], ...
    CenterRectOnPoint([0,0,init.load_bar_dimensions(1),init.load_bar_dimensions(2)], hor_align, ver_align), 3);

   Screen(w, 'Flip');
   if i == 25
      img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
   end
   waitfor(rate_obj);
end

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Walk through #4
Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Choose a spaceship to explore the galaxy...'
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

[selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);
type = 0;
[action(1,1), choice_loc] = task_func.choice(type, [L,R], selection, x, y);
% ---- feedback screen
if choice_loc == L
    % draw background
    Screen('DrawTexture', w, planet_home, [], space_bg);
    % draw original stimuli
    Screen('DrawTexture', w, A1, [], alien_Lpoint);
    Screen('DrawTexture', w, B1, [], alien_Rpoint);
    % draw frames around original stimuli
    Screen('FrameRect',w,chosen_color,alien_Lframe,10);
    Screen('FrameRect',w,frame_color,alien_Rframe,10);
    Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

elseif choice_loc == R
   % draw background
   Screen('DrawTexture', w, planet_home, [], space_bg);
   % draw original stimuli
   Screen('DrawTexture', w, A1, [], alien_Lpoint);
   Screen('DrawTexture', w, B1, [], alien_Rpoint);
   % draw frames around original stimuli
   Screen('FrameRect',w,frame_color,alien_Lframe,10);
   Screen('FrameRect',w,chosen_color,alien_Rframe,10);
   Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
end

% ---- wait 1 second on the feedback screen
WaitSecs(init.feedback_time);

% ---- space exploration page
Screen('DrawTexture', w, space, [], space_bg);
if choice_loc == L
    ship_out = A1_out;
    ship_return = A1_return;
elseif choice_loc == R
    ship_out = B1_out;
    ship_return = B1_return;
end
Screen('DrawTexture', w, ship_out, [], spaceship_out);
Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
WaitSecs(init.explore_time);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,white,alien_Lframe,10);
Screen('FrameRect',w,white,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Now you ask one alien if they have space treasure to share.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

[selection, x, y] = task_func.selection(init.input_source, [L,R], w, rects);
[action(1,2), choice_loc] = task_func.choice(type, [L,R], selection, x, y);
% ---- feedback screen
if choice_loc == L
    % draw background
    Screen('DrawTexture', w, planet_3, [], space_bg);
    % draw original stimuli
    Screen('DrawTexture', w, A3, [], alien_Lpoint);
    Screen('DrawTexture', w, B3, [], alien_Rpoint);
    % draw frames around original stimuli
    Screen('FrameRect',w,chosen_color,alien_Lframe,10);
    Screen('FrameRect',w,frame_color,alien_Rframe,10);
    Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

elseif choice_loc == R
   % draw background
   Screen('DrawTexture', w, planet_3, [], space_bg);
   % draw original stimuli
   Screen('DrawTexture', w, A3, [], alien_Lpoint);
   Screen('DrawTexture', w, B3, [], alien_Rpoint);
   % draw frames around original stimuli
   Screen('FrameRect',w,frame_color,alien_Lframe,10);
   Screen('FrameRect',w,chosen_color,alien_Rframe,10);
   Screen('Flip', w); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
end
WaitSecs(init.feedback_time); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);

if choice_loc == L
    Screen('DrawTexture', w, A3, [], alien_win);
elseif choice_loc == R
    Screen('DrawTexture', w, B3, [], alien_win);
end
Screen('DrawTexture', w, treasure, [], treasure_win);
DrawFormattedText(w, 'Win!', 'center', rect(4)*0.8, white);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Nice Job! You chose an alien who had space treasure to share!' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'Let''s learn more about the aliens.' '\n' ...
    'This will help you find more space treasure.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Alien programming
Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'Each alien goes into their cave to dig for space treasure each day.' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'Digging for space treasure is hard work and requires good luck!' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'Each day the aliens may or may not find space treasure to share with you.' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'Some aliens may be able to share more often than other aliens.' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, A2, [], alien_miner);
Screen('DrawTexture', w, mines_rich, [], mines);
DrawFormattedText(w,[
    'If an alien finds lots of space treasure at the top of their cave...' '\n' ...
    'they will be able to share space treasure on most days.' ...
    ],'center',rect(4)*0.8, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, B3, [], alien_miner);
Screen('DrawTexture', w, mines_poor, [], mines);
DrawFormattedText(w,[
    'If an alien has to dig through lots of rock to find space treasure...' '\n' ...
    'they will not be able to share space treasure on most days.' ...
    ],'center',rect(4)*0.8, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'But remember that each alien is slowly digging in their cave each day.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, A2, [], alien_miner);
Screen('DrawTexture', w, mines_rich_exc, [], mines);
DrawFormattedText(w,[
    'The alien that had lots of space treasure to share in the beginning may slowly run out.' ...
    ],'center',rect(4)*0.8, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, B3, [], alien_miner);
Screen('DrawTexture', w, mines_poor_exc, [], mines);
DrawFormattedText(w,[
    'And the alien that had to dig through lots of rock in the beginning,' '\n' ...
    'may slowly uncover space treasure to share!' ...
    ],'center',rect(4)*0.8, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'This means you will have to pay close attention.' '\n' ...
    'How much the aliens can share will slowly change over time.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Spaceship programming
DrawFormattedText(w,[
    'Let''s learn more about your spaceships.' '\n' ...
    'This will help you find more space treasure.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'Both of your spaceships can land on both planets...' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'but each spaceship is different.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'One spaceship will land on Planet ' state2_name ' most of the time.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_2, [], space_bg);
Screen('DrawTexture', w, A2, [], alien_Lpoint);
Screen('DrawTexture', w, B2, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'This is where the ' state2_color ' aliens live.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'The other spaceship will land on Planet ' state3_name ' most of the time.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_3, [], space_bg);
Screen('DrawTexture', w, A3, [], alien_Lpoint);
Screen('DrawTexture', w, B3, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'This is where the ' state3_color ' aliens live.' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'To win the most space treasure, you need to pay' '\n'...
    'close attention to where your spaceships are landing.' '\n\n' ...
    'If an alien on one planet has the most space treasure to share,' '\n' ...
    'you want to choose the spaceship that is most likely to land there!'
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% Questions?
DrawFormattedText(w,[
    'Now we have given you all of the information you need to win' '\n'...
    'lots of space treasure, but there was a lot to remember.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'Lucky for you, ' init.researcher ' is here to help...' ...
    ],'center','center', white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, cave, [], caves{1});
Screen('DrawTexture', w, cave, [], caves{2});
Screen('DrawTexture', w, cave, [], caves{3});
Screen('DrawTexture', w, cave, [], caves{4});
Screen('DrawTexture', w, A2, [], four_aliens{1});
Screen('DrawTexture', w, B2, [], four_aliens{2});
Screen('DrawTexture', w, A3, [], four_aliens{3});
Screen('DrawTexture', w, B3, [], four_aliens{4});
DrawFormattedText(w,[
    'What questions do you have for ' init.researcher ' about the aliens and their caves?' ...
    ],'center',rect(4)*0.75, white, [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('DrawTexture', w, planet_home, [], space_bg);
Screen('DrawTexture', w, A1, [], alien_Lpoint);
Screen('DrawTexture', w, B1, [], alien_Rpoint);
Screen('FrameRect',w,frame_color,alien_Lframe,10);
Screen('FrameRect',w,frame_color,alien_Rframe,10);
Screen('FillRect', w, black, txt_bg);
DrawFormattedText(w,[
    'What questions do you have for ' init.researcher ' about the spaceships?' ...
    ],'center','center', white, [], [], [], 1.6, [], txt_bg);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);
% -------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% -----------------------------------------------------------------------------
% End
DrawFormattedText(w,[
    'Congratulations Space Captain!' '\n\n' ...
    'You now have all of the knowledge you need to explore' '\n' ...
    'the galaxy and find space treasure!' ...
    ], 'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

DrawFormattedText(w,[
    'Now it is time for your training quest.' '\n\n' ...
    'We are going to explore this galaxy for 10 days.' '\n\n' ...
    'At the end of those 10 days, you will have completed training camp!' ...
    ], 'center','center', [], [], [], [], 1.6);
Screen('Flip',w);
WaitSecs(init.pause_to_read); img_idx = task_func.get_img(img_idx, init, init.img_collect_on, w);
task_func.advance_screen(init.input_source);

Screen('TextSize', w, init.textsize);
Screen(w, 'FillRect', black);
DrawFormattedText(w,[
    'When you are ready, ' init.researcher ' will load the training quest.' ...
    ],'center','center', white, [], [], [], 1.6);
Screen(w, 'Flip');
WaitSecs(1);;
task_func.advance_screen(init.input_source);

ShowCursor;
Screen('CloseAll');
FlushEvents;

end
