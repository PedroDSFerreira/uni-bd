function getObj(searchField, objType, successCallback) {
    $.ajax({
        url: '/api/' + objType + '/?' + searchField,
        method: 'GET',
        success: function(response) {
            successCallback(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function addObj(data, objType) {
    $.ajax({
        url: '/api/' + objType + '/',
        method: 'POST',
        data: data,
        contentType: 'application/json',
        success: function(response) {
            // if body contains 'roles', send pach request
            if (data.includes('roles')) {
                var applicantId = response.id;
                // send  'roles' field as json
                var newData = JSON.stringify({
                    roles: JSON.parse(data).roles
                });
                
                patchObj(applicantId, newData, 'applicants');
            }

            window.location.reload(true);
        },
        error: function(xhr, status, error) {
            alert('Error: ');
        }
    });
}

function deleteObj(id, objType) {
    $.ajax({
        url: '/api/' + objType + '/' + id + '/',
        method: 'DELETE',
        contentType: 'application/json',
        success: function(response) {
            window.location.reload(true);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}


function updateObj(id, newData, objType) {
    $.ajax({
        url: '/api/' + objType + '/' + id + '/',
        method: 'PUT',
        data: newData,
        contentType: 'application/json',
        success: function(response) {
            window.location.reload(true);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function patchObj(id, newData, objType) {
    $.ajax({
        url: '/api/' + objType + '/' + id + '/',
        method: 'PATCH',
        data: newData,
        contentType: 'application/json',
        success: function(response) {
            window.location.reload(true);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function getStatuses(successCallback) {
    $.ajax({
        url: '/api/statuses/',
        method: 'GET',
        success: function(response) {
            successCallback(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function parseBody(data) {
    var body = {};
    var roles = [];
    for (var i = 0; i < data.length; i++) {
      if (data[i].name == 'roles') {
        roles.push({"role":data[i].value});
      } else {
        body[data[i].name] = data[i].value;
      }
    }
    body['roles'] = roles;
    return JSON.stringify(body);
}