/*
 * Copyright 2015 Benedikt Ritter
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import AddPlayersController from './AddPlayersController';

describe('AddPlayersController', () => {

    let ctrl;

    beforeEach(() => {
        ctrl = new AddPlayersController();
    });

    it('should have an players array defined', () => {
        expect(ctrl.players).toBeDefined();
    });

    it('should have an empty players array initially', () => {
        expect(ctrl.players).toBeEmptyArray();
    });

    it('should add new players to the players array', () => {
        ctrl.playerToBeAdded = 'John Doe';
        ctrl.addPlayer();

        expect(ctrl.players).toContain('John Doe');
    });

    it('should clear playerToBeAdded after adding a player', () => {
        ctrl.playerToBeAdded = 'John Doe';
        ctrl.addPlayer();

        expect(ctrl.playerToBeAdded).toBe('');
    });

    it('should not add empty players to the players array', () => {
        ctrl.addPlayer('');

        expect(ctrl.players).toBeEmptyArray();
    });
});