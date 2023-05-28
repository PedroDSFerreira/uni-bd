$(document).ready(function() {
    getObj('', 'roles', fillTable);
});

$('#search').submit(function(e) {
    e.preventDefault();
    var searchField = $(this).serialize();
    getObj(searchField, 'roles', fillTable);
});

$('#create').submit(function(e) {
    e.preventDefault();
    var formData = $(this).serializeArray();
    var jsonData = {};

    // Convert serialized form data to JSON object
    $.each(formData, function(index, field) {
        jsonData[field.name] = field.value;
    });

    var data = JSON.stringify(jsonData);
    addObj(data, 'roles');
});


$(document).ready(function() {
    $('#editModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget); // Get the button that triggered the modal
        var roleId = button.data('role-id');
        var roleName = button.data('role-name');
        var modal = $(this);
        
        // Set the value of the input field in the modal
        modal.find('#editRoleName').val(roleName);
        
        modal.find('#saveChangesBtn').click(function() {
            var updatedRoleName = modal.find('#editRoleName').val();
            var newData = {
                name: updatedRoleName
            }
            updateObj(roleId, JSON.stringify(newData), 'roles')
        });
    });
});


function fillTable(data) {
    var table = $('#role-list');
    table.empty();
    if (data.length == 0) {
        table.append(
            `<tr>
            <td colspan="2">No data found</td>
            </tr>`
            )
        }
        
        for (var i = 0; i < data.length; i++) {
            table.append(
                `<tr>
                <td>${data[i].name}</td>
                <td>
                <a data-toggle="modal" data-target="#editModal" data-role-name="${data[i].name}" data-role-id="${data[i].id}" class="text-primary" title="Edit">
                <i class="fas fa-pencil-alt"></i>
                </a>
                <a onclick="deleteObj(${data[i].id},'roles')" class="text-danger ml-2" title="Delete">
                <i class="fas fa-trash"></i>
                </a>
                </td>
                </tr>`
                
                )
            }
        }