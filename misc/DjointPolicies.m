function polInfo=DjointPolicies()
%% function polInfo=DjointPolicies()
% TRAJECTORY [1,3]
% 1 = square = blue   %  0 = circle = red

LONG            = 1;
SHORT           = 2;
WAITSandMIDDLE  = 3;
MIDDLEandWAITS  = 4;
WAITS           = 5;

polInfo.LONG            = LONG;
polInfo.SHORT           = SHORT;
polInfo.WAITSandMIDDLE  = WAITSandMIDDLE;
polInfo.MIDDLEandWAITS  = MIDDLEandWAITS;
polInfo.WAITS           = WAITS;

polInfo.COL_STRATEGY1   = 1;       
polInfo.COL_GOAL1       = 2;       
polInfo.COL_STRATEGY2   = 3;       
polInfo.COL_GOAL2       = 4;       

TrajInfo={'long', 'short', 'waits and middle', 'middle and waits', 'waits'};

% 1 = square = blue   %  0 = circle = red
% GoalInfo={'0','1','no goal'};
% GoalInfo={'circle','square','no goal'};
GoalInfo={'red','blue','no goal'};

CIRCLE          = 1;
SQUARE          = 2;
NOGOAL          = 3;

P_INDEX( 1,:)=[LONG,          CIRCLE,           LONG,  CIRCLE];
P_INDEX( 2,:)=[LONG,          SQUARE,           LONG,  SQUARE];
P_INDEX( 3,:)=[SHORT,         CIRCLE,           LONG,  CIRCLE];
P_INDEX( 4,:)=[SHORT,         SQUARE,           LONG,  SQUARE];
P_INDEX( 5,:)=[SHORT,         CIRCLE,          SHORT,  CIRCLE];

%     {'T1, T2 long policy to circle'                              } LC1LC2 
%     {'T1, T2 long policy to square'                              } LS1LS2
%     {'T1 straight policy to circle, T2 long policy to circle'    } SC1LC2
%     {'T1 straight policy to square, T2 long policy to square'    } SC1LC2
%     {'T1 and T2 straight policy to circle'                       }

P_INDEX( 6,:)=[         SHORT, CIRCLE,          SHORT, SQUARE];
P_INDEX( 7,:)=[         SHORT, SQUARE,          SHORT, CIRCLE];
P_INDEX( 8,:)=[         SHORT, SQUARE,          SHORT, SQUARE];
P_INDEX( 9,:)=[WAITSandMIDDLE, SQUARE,           LONG, SQUARE];
P_INDEX(10,:)=[MIDDLEandWAITS, SQUARE,           LONG, SQUARE];

%     {'T1 straight policy to circle, T2 straight policy to square'}
%     {'T1 straight policy to square, T2 straight policy to circle'}
%     {'T1 and T2 straight policy to square'                       }
%     {'T1 waits and middle to square, T2 long policy to square'   }
%     {'T1 middle and waits to square, T2 long policy to square'   }

P_INDEX(11,:)=[          LONG, SQUARE, MIDDLEandWAITS, SQUARE];
P_INDEX(12,:)=[          LONG, SQUARE, WAITSandMIDDLE, SQUARE];
P_INDEX(13,:)=[WAITSandMIDDLE, CIRCLE,           LONG, CIRCLE];
P_INDEX(14,:)=[MIDDLEandWAITS, CIRCLE,           LONG, CIRCLE];
P_INDEX(15,:)=[          LONG, CIRCLE, MIDDLEandWAITS, CIRCLE];


%     {'T1 long policy to square, T2 middle and waits to square'   }
%     {'T1 long policy to square, T2 waits and middle to square'   }
%     {'T1 waits and middle to circle, T2 long policy to circle'   }
%     {'T1 middle and waits to circle, T2 long policy to circle'   }
%     {'T1 long policy to circle, T2 middle and waits to circle'   }

P_INDEX(16,:)=[          LONG, CIRCLE, WAITSandMIDDLE, CIRCLE];
P_INDEX(17,:)=[          LONG, SQUARE,           LONG, CIRCLE];
P_INDEX(18,:)=[          LONG, CIRCLE,           LONG, SQUARE];
P_INDEX(19,:)=[MIDDLEandWAITS, CIRCLE,           LONG, SQUARE];
P_INDEX(20,:)=[MIDDLEandWAITS, SQUARE,           LONG, CIRCLE];


%     {'T1 long policy to circle, T2 waits and middle to circle'   }
%     {'T1 long policy to square, T2 long policy to circle'        }
%     {'T1 long policy to circle, T2 long policy to square'        }
%     {'T1 middle and waits to circle, T2 long policy to square'   }
%     {'T1 middle and waits to square, T2 long policy to circle'   }

P_INDEX(21,:)=[          LONG, CIRCLE,          SHORT, CIRCLE];
P_INDEX(22,:)=[          LONG, SQUARE,          SHORT, SQUARE];
P_INDEX(23,:)=[          LONG, SQUARE, MIDDLEandWAITS, CIRCLE];
P_INDEX(24,:)=[          LONG, CIRCLE, MIDDLEandWAITS, SQUARE];
P_INDEX(25,:)=[         WAITS, NOGOAL,          WAITS, NOGOAL];


%     {'T1 long policy to circle, T2 straight policy to circle'    }
%     {'T1 long policy to square, T2 straight policy to square'    }
%     {'T1 long policy to square, T2 middle and waits to circle '  }
%     {'T1 long policy to circle, T2 middle and waits to square '  }
%     {'T1, T2 wait'                                               }
polInfo.P_INDEX         = P_INDEX;
polInfo.TrajInfo        = TrajInfo;
polInfo.GoalInfo        = GoalInfo;
polInfo.LONG            = LONG;
polInfo.SHORT           = SHORT;
polInfo.WAITSandMIDDLE  = WAITSandMIDDLE;
polInfo.MIDDLEandWAITS  = MIDDLEandWAITS;
polInfo.WAITS           = WAITS;
polInfo.CIRCLE          = CIRCLE;
polInfo.SQUARE          = SQUARE;
polInfo.NOGOAL          = NOGOAL;

Np                      = size(polInfo.P_INDEX,1);
allpolstr               = cell(1,Np);
for ip=1:Np
    trajpol=polInfo.P_INDEX(ip,:);
    strpol=printPolinfo(trajpol,polInfo);
    allpolstr{ip}=strpol;
end
polInfo.policy_labels   = allpolstr;
