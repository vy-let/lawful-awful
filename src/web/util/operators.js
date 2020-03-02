import { filter } from 'rxjs/operators';

export const ofType = (...types) =>
  filter(({ type }) => types.some( t => t === type ));
