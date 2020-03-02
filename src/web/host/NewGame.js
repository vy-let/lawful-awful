import React from 'react';

import { of as observableOf } from 'rxjs';
import { ajax } from 'rxjs/ajax';
import { map, mergeMap, filter, tap, withLatestFrom, catchError } from 'rxjs/operators';
import { ofType } from '../util/operators';



export const updateTheme = (action$, state$) => action$.pipe(
  ofType('theme_changed'),
  withLatestFrom(state$),
  map(([ {type, payload}, state ]) => ({
    ...state,
    gameTheme: payload,
  })),
);



export const startNewGame = (action$, state$) => action$.pipe(
  ofType('new_game'),
  withLatestFrom(state$),
  mergeMap(([ action, state ]) => ajax(
    { url: '/api/games/new',
      method: 'POST',
      body: { theme: state.gameTheme }})),

  map(({ response }) => (
    { type: 'start_game', payload: { accessHash: response.accessHash,
                                     playerCode: response.playerCode }})),

  catchError( e => (
    { type: 'start_game_error', payload: e })),
);



export const NewGame = ({ gameTheme, actions }) => (
  <div>
    <label>
      <p>Pick a theme for the game:</p>
      <input type="text"
             value={gameTheme}
             onChange={e => actions.next({ type: 'theme_changed', payload: e.target.value })} />
    </label>

    <button disabled={gameTheme.length < 1}
            onClick={_ => actions.next({ type: 'new_game', payload: null })} >Start Game</button>
  </div>
);
