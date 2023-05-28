var jsonData;

$(document).ready(function() {
    var currentUrl = window.location.pathname;
    var parts = currentUrl.split('/');
    parts.pop();
    id = parts.pop();
    getObj('id=' + id, 'applicants', fillTable);
    getStatuses(fillCreateForm);
});

$('#create').submit(function(e) {
    e.preventDefault();
    var data = $(this).serializeArray();
    var body = parseBody(data);
    
    patchObj(jsonData.id, body, 'applicants');
});

$(document).ready(function() {
    $('#editModal').on('show.bs.modal', function(event) {
        var button = $(event.relatedTarget); // Get the button that triggered the modal
        var applicantId = button.data('role-id');
        var rowValues = getRowValues(applicantId);
        var modal = $(this);
        
        // Set the value of the input field in the modal
        modal.find('#editName').val(rowValues[0]);
        
        modal.find('#saveChangesBtn').click(function() {
            var dropdownField = document.getElementById('dropdownField').value;
            var role = modal.find('#editName').val();
            
            if (dropdownField == '') {
                alert('Please select a status');
                return;
            }
            
            var newData = {
                "roles": [
                    {
                        "role": role,
                        "status": dropdownField
                    }
                ]
            }
            
            patchObj(id, JSON.stringify(newData), 'applicants')
        });
    });
});


function fillTable(data) {
    jsonData = data[0];
    var profileTable = $('#applicant-profile');
    profileTable.empty();
    if (data.length == 0) {
        profileTable.append(
            `<tr>
            <td colspan="2">No data found</td>
            </tr>`
            );
        }
        
    profileTable.append(
        `<tr>
        <td>Name</td>
        <td id="name">${data[0].name}</td>
        </tr>
        <tr>
        <td>Phone number</td>
        <td id="phone">${data[0].phone_number}</td>
        </tr>
        <tr>
        <td>Email</td>
        <td id="email">${data[0].email}</td>
        </tr>`
        );
        
    var rolesList = $('#roles-list');
    rolesList.empty();
    if (data[0].roles.length == 0) {
        rolesList.append(
            `<tr>
            <td colspan="4">No data found</td>
            </tr>`
            );
        }
        
    for (var i = 0; i < data[0].roles.length; i++) {
        rolesList.append(
            `<tr id="${data[0].roles[i].id}">
            <td>${data[0].roles[i].role}</td>
            <td>${data[0].roles[i].status}</td>
            <td>
            <a data-toggle="modal" data-target="#editModal" data-role-name="${data[0].roles[i].name}" data-role-id="${data[0].roles[i].id}" class="text-primary" title="Edit">
            <i class="fas fa-pencil-alt"></i>
            </a>
            <a onclick="deleteApplRole('${data[0].roles[i].role}')" class="text-danger ml-2" title="Delete">
            <i class="fas fa-trash"></i>
            </a>
            </td>
            </tr>`
            );
        }
    
    getObj('', 'roles', fillForm);
}
                
function fillCreateForm(data) {
    // from JSON request, fill in the form
    var dropdownField = document.getElementById('dropdownField');
    
    for (var i = 0; i < data.length; i++) {
        dropdownField.innerHTML += `<option value="${data[i]['name']}">${data[i]['name']}</option>`;
    }
    
}

function deleteApplRole(role) {
    // Find role in jsonData and remove it
    var roles = jsonData.roles;
    for (var i = 0; i < roles.length; i++) {
        if (roles[i].role === role) {
            roles.splice(i, 1);
            break;
        }
    }
    
    // Send updated jsonData to updateObj
    var updatedData = {
        id: jsonData.id,
        name: jsonData.name,
        phone_number: jsonData.phone_number,
        email: jsonData.email,
        roles: roles
    };
    updateObj(jsonData.id, JSON.stringify(updatedData), 'applicants');
}

function getRowValues(id) {
    // Get the table row with the ID "myTableRow"
    var tableRow = document.getElementById(id);
    
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

function fillForm(data) {
    // compare roles in jsonData with roles in data and remove the ones that are already in jsonData
    var roles = jsonData.roles;
    for (var i = 0; i < roles.length; i++) {
        for (var j = 0; j < data.length; j++) {
            if (roles[i].role === data[j].name) {
                data.splice(j, 1);
                break;
            }
        }
    }
    
    
    var form = $('#create-modal-roles');
    form.empty();
    
    for (var i = 0; i < data.length; i++) {
        form.append(
            `<div class="form-check">
            <input class="form-check-input" type="checkbox" name="roles" id="role-${data[i].id}" value="${data[i].name}">
            <label class="form-check-label" for=""role-${data[i].id}"">${data[i].name}</label>
            </div>`
            )
        }
    }
