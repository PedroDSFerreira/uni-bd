var user_id = 1;
$(document).ready(function() {
    // get all classes
    $.ajax({
        url: '/api/list_classes?user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            console.log(response);
            fillClasses(response);

        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });

    $.ajax({
        url: '/api/list_tasks?user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            fillTable(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });

    $('#editModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget); // Get the button that triggered the modal
        var taskId = button.data('task-id');
        var rowValues = getRowValues(taskId);
        var modal = $(this);
        
        // Set the value of the input field in the modal
        modal.find('#editName').val(rowValues[0]);
        modal.find('#editDescription').val(rowValues[1]);
        modal.find('#editClass').val(rowValues[2]);
        modal.find('#editGroup').val(rowValues[3]);
        modal.find('#editStartDate').val(rowValues[4]);
        modal.find('#editEndDate').val(rowValues[5]);
        modal.find('#editPriority').val(rowValues[6]);
        modal.find('#editStatus').val(rowValues[7]);
        
        
        modal.find('#saveChangesBtn').click(function() {
            var updatedTaskName = modal.find('#editName').val();
            var updatedDescription = modal.find('#editDescription').val();
            var updatedClass = modal.find('#editClass').val();
            var updatedGroup = modal.find('#editGroup').val();
            var updatedStartDate = modal.find('#editStartDate').val();
            var updatedEndDate = modal.find('#editEndDate').val();
            var updatedPriority = modal.find('#editPriority').val();
            var updatedStatus = modal.find('#editStatus').val();
            var updatedIsPublic = modal.find('#editIsPublic').val();
            console.log(updatedIsPublic);
            if (updatedIsPublic == "on") {
                updatedIsPublic = true;
            }
            else {
                updatedIsPublic = false;
            }
            var newData = {
                "task_id": taskId,
                "user_id": user_id,
                "task_name": updatedTaskName,
                "description": updatedDescription,
                "class_name": updatedClass,
                "group": updatedGroup,
                "start_date": updatedStartDate,
                "end_date": updatedEndDate,
                "priority_lvl": updatedPriority,
                "status": updatedStatus,
                "is_public": updatedIsPublic
            }
            console.log(newData);

            updateTask(JSON.stringify(newData));
          
          
        });
      });
});

function fillTable(response) {
    var table = $('#tasks_table');
    var tbody = table.find('tbody');
    tbody.empty();

    if (response.length === 0) {
        tbody.append(
            `<tr>
                <td colspan="9">No data found</td>
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
            row.append(`
                <td>
                    <a data-toggle="modal" data-target="#editModal" data-task-name="${task.task_name}" data-task-id="${task.task_id}" class="text-primary" title="Edit">
                        <i class="fas fa-pencil-alt"></i>
                    </a>
                    <a onclick="deleteTask(${task.task_id})" class="text-danger ml-2" title="Delete">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>`
            );

            tbody.append(row);
        }
    }
}



function deleteTask(taskId) {
    var data = {
        "task_id": taskId
    }
    $.ajax({
        url: '/api/delete_task',
        method: 'POST',
        data: JSON.stringify(data),
        success: function(response) {
            $('#task-' + taskId).remove();
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function updateTask(data) {
    $.ajax({
        url: '/api/update_task',
        method: 'POST',
        data: data,
        contentType: 'application/json',
        success: function(response) {
            // window.location.reload();
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function getRowValues(id) {
    // Get the table row with the ID "myTableRow"
    var tableRow = document.getElementById('task-' + id);

    // Get all the <td> elements within the table row
    var tdElements = tableRow.getElementsByTagName('td');

    // Loop through the <td> elements and retrieve their values
    var tdValues = [];
    for (var i = 0; i < tdElements.length-1; i++) {
        var tdValue = tdElements[i].innerText;
        tdValues.push(tdValue);
    }

    return tdValues;
}

function fillClasses(response) {
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

