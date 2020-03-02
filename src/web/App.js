import React, { useState } from 'react';



const priorRole = localStorage.getItem('role');



const EntryLayout = ({ children }) => (
  <>
    <h1>Lawful Awful</h1>
    { children }
  </>
);



export const App = props => {
  const [ role, setRole ] = useState(priorRole);
  const [ interactedYet, setInteracted ] = useState(false);
  const [ AppLib, setAppLib ] = useState(null);
  const [ loadingError, setError ] = useState(null);

  const reset = () => {
    setRole(null);
    setInteracted(true);
    setAppLib(null);
    setError(null);
    localStorage.removeItem('role');
  };

  const become = role => {
    setInteracted(true);
    setError(null);

    const appLibPromise = role === 'player'
          ? import(/* webpackChunkName: "player" */ './player/PlayerApp')
          : import(/* webpackChunkName: "host" */ './host/HostApp');

    appLibPromise.then(({ AppLib }) => {
      setAppLib(AppLib);
    }).catch( e => {
      setError(e);
    });

    setRole(role);
    localStorage.setItem('role', role);
  };

  const resume = () => become(role);

  // The buttons are keyed here to keep focus from persisting from one
  // state to the next

  if (loadingError) {
    return (
      <EntryLayout>
        <p>Error loading the {role} code. {loadingError.message}</p>
        <p>Please check your network and try again.</p>
        <button key="tryagain" onClick={resume}>Try Again</button>
      </EntryLayout>
    )

  } else if (!interactedYet && role) {
    // Ask if they want to resume a game
    const verb = role === 'player' ? 'playing' : 'running';
    return (
      <EntryLayout>
        <p>It looks like you were {verb} a game. Would you like to continue?</p>
        <button key="reset" onClick={reset}>Reset</button>
        <button key="continue" onClick={resume}>Continue</button>
      </EntryLayout>
    )

  } else if (!role) {
    // Ask what kind of game they want to play
    return (
      <EntryLayout>
        <p>Would you like to play a game, or host a new game?</p>
        <button key="play" onClick={_ => become('player') }>Play a Game</button>
        <button key="host" onClick={_ => become('host') }>Host a New Game</button>
      </EntryLayout>
    )

  } else if (!AppLib) {
    // Still loading
    return (
      <EntryLayout>
        <p>Loading...</p>
      </EntryLayout>
    );

  } else {
    // Render the game
    const AppComponent = AppLib.component;
    return <AppComponent onReset={reset} />;
  }
}
