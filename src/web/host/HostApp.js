import React, { useState, useEffect } from 'react';
import { BehaviorSubject, Subject, merge } from 'rxjs';
import { map, withLatestFrom, ignoreElements } from 'rxjs/operators';
import { ofType } from '../util/operators';

import { NewGame, updateTheme, startNewGame } from './NewGame';



const APP_PHASES = {
  NEW: 'NEW',
  LOADING: 'LOADING',
  PLAYING: 'PLAYING',
  ENDED: 'ENDED',
};



const initialState = {
  currentPhase: APP_PHASES.NEW,
  gameTheme: "",
  accessHash: null,
  playerCode: null,
  socket: null,
  gameState: null,
};



const stator = (action$, state$) => merge(
  updateTheme(action$, state$),

  action$.pipe(
    ofType('new_game'),
    withLatestFrom(state$),
    map(([ _, state ]) => (
      { ...state,
        currentPhase: APP_PHASES.LOADING })),
  ),

  action$.pipe(
    ofType('start_game'),
    withLatestFrom(state$),
    map(([ { payload }, state ]) => (
      { ...state,
        accessHash: payload.accessHash,
        playerCode: payload.playerCode,
        currentPhase: APP_PHASES.PLAYING })),
  ),
);



const epic = (action$, state$) => merge(
  startNewGame(action$, state$),
);



const HostApp = props => {
  const { onReset } = props;
  const [ state$, _changeState$ ] = useState(() => new BehaviorSubject(initialState));
  const [ state, updateState ] = useState(initialState);
  const [ action$, _changeAction$ ] = useState(() => new Subject());

  // Discount RSM
  useEffect(() => {
    const statorSub = stator(action$, state$).subscribe(state$);
    const actionSub = epic(action$, state$).subscribe(action$);
    const stateSub = state$.subscribe( st => updateState(st) );

    return () => {
      stateSub.unsubscribe();
      statorSub.unsubscribe();
      actionSub.unsubscribe();
      state$.complete();
      action$.complete();
    }
  }, [state$, action$]);



  if (state.currentPhase === APP_PHASES.NEW) {
    return <NewGame gameTheme={state.gameTheme} actions={action$} />;

  } else if (state.currentPhase === APP_PHASES.LOADING) {
    return <p>Loading...</p>;

  } else if (state.currentPhase === APP_PHASES.PLAYING) {
    return <p>To-do</p>;

  } else {
    return <div>
            <p>The game has ended.</p>
             <button onClick={onReset}>Start Over</button>
           </div>;
  }
}



export const AppLib = { component: HostApp };
