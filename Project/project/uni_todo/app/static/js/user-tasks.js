// get id from url
var tmp = window.location.href.split('/');
tmp.pop()
var user_id = parseInt(tmp.pop());
var classes = [];
$(document).ready(function() {
    // get all classes
    $.ajax({
        url: '/api/list_classes?user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            fillClasses(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });


    $.ajax({
        url: '/api/get_user?user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            $('#title').text(response.name);
            $('#university').text(response.university);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });

    $.ajax({
        url: '/api/list_tasks?is_public=1&user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            fillTable(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
});

function fillTable(response) {
    var table = $('#tasks_table');
    var tbody = table.find('tbody');
    tbody.empty();

    if (response.length === 0) {
        tbody.append(
            `<tr>
                <td colspan="9">No tasks found</td>
            </tr>`
        );
    } else {
        for (var i = 0; i < response.length; i++) {
            var task = response[i];
            var row = $('<tr id="task-' + task.task_id + '"></tr>');
            row.append('<td>' + task.task_name + '</td>');
            row.append('<td>' + task.description + '</td>');
            row.append('<td>' + task.class_name + '</td>');
            row.append('<td>' + task.group + '</td>');
            row.append('<td>' + task.start_date + '</td>');
            row.append('<td>' + task.end_date + '</td>');
            row.append('<td>' + task.priority_lvl + '</td>');
            row.append('<td>' + task.status + '</td>');
            tbody.append(row);
        }
    }
}


function fillClasses(response) {
    // fill dict with classes
    for (var i = 0; i < response.length; i++) {
        classes[response[i].id] = response[i].name;
    }

    // fill the select with classes
    // edit
    var select = $('#editClass');
    select.empty();
    select.append('<option value="" disabled selected>Select a class</option>');
    for (var i = 0; i < response.length; i++) {
        select.append('<option value="' + response[i].id + '">' + response[i].name + '</option>');
    }

    // create
    var select = $('#createClass');
    select.empty();
    select.append('<option value="" disabled selected>Select a class</option>');
    for (var i = 0; i < response.length; i++) {
        select.append('<option value="' + response[i].id + '">' + response[i].name + '</option>');
    }
}

