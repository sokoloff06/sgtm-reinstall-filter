___SANDBOXED_JS_FOR_SERVER___

/**
 * @license
 * Copyright 2024 Google LLC
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

// Enter your template code here.
const log = require('logToConsole');
const getAllEventData = require('getAllEventData');
const Firestore = require('Firestore');
const collection = 'users'
const projectID = 'sokolovv-arp'
const eventData = getAllEventData();
const userId = eventData.x - ga - mp2 - user_properties.user_id;
const deviceId = eventData.x - ga - resettable_device_id;
log('data: ', data);
log('allEventData: ', getAllEventData());
if (eventData.event_name === 'first_open') {
    existsInFirestore(collection, userId, deviceId).then(exists => {
        if (exists) {
            log('user exists! Renaming event')
            eventData.event_name = 'reinstall'
        } else {
            log('user does not exist!')
            //TODO: write to Firestore users table
        }
    });
} else {
    log('not first open event!')
}
// Call data.gtmOnSuccess when the tag is finished.
data.gtmOnSuccess();


async function existsInFirestore(collection, userId, deviceId) {
    const queries = [
        ['id', '==', userId],
        ['device_id', '==', deviceId]
    ];
    const result = await Firestore.query(`${collection}`, queries, {
        projectId: `${projectID}`,
        limit: 1,
    });
    return result.length === 0;
}


