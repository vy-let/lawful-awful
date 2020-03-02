import React, { useState } from 'react';
import ReactDOM from 'react-dom';

import { App } from './App';



const rootElement = document.createElement('div');
rootElement.id = 'app';
document.body.appendChild(rootElement);

ReactDOM.render(
  <App/>,
  rootElement
);
