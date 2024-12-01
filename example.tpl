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

const Firestore = require('Firestore');
const log = require('logToConsole');
const Promise = require('Promise');
const firestorePath = data.collectionId + '/' + data.documentId;
const eventData = {};

function writeToFirestore(path, input, replace){
  Firestore.write(path, input, {
    projectId: data.gcpProjectId,
    merge: replace,
  }).then(() => {
    log('Firestore success: ', input);
    data.gtmOnSuccess();
  },data.gtmOnFailure);
}



function getFirestoreValue(path, attributes) {

  return Promise.create((resolve) => {
    return Firestore.read(path, { projectId: data.gcpProjectId })
      .then((result) => {
      
      attributes.forEach(param => {
        if(param.overwrite === true && param.value){
          eventData[param.attribute] = param.value;
        }
        if(param.overwrite === false && param.value){
            if(!result.data.hasOwnProperty(param.attribute)){
              eventData[param.attribute] = param.value;
            }
        }
      });
    })
      .catch((error) => {
      if(error.reason === 'not_found'){
        attributes.forEach(param => {
          if(param.value){
            eventData[param.attribute] = param.value;
          }
        });
      } else {
      log(error);
      }
    })
      .finally(() => {
      resolve(writeToFirestore(firestorePath, eventData, true));
    });
  });
}

  
if(data.action === 'replace'){
  data.attributesReplace.forEach(param => {
    if(param.value){
      eventData[param.attribute] = param.value;
    }
  });
  writeToFirestore(firestorePath, eventData, false);
}


if(data.action === 'editOrAdd') {
  getFirestoreValue(firestorePath, data.attributesEditAdd); 
}