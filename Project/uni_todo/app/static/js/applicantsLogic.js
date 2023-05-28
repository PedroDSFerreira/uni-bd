
$(document).ready(function() {
  getObj('', 'applicants', fillTable);
  getObj('', 'roles', fillForm);
});

$('#search').submit(function(e) {
  e.preventDefault();
  var searchField = $(this).serialize();
  getObj(searchField, 'applicants', fillTable);
});

$('#create').submit(function(e) {
  e.preventDefault();
  var data = $(this).serializeArray();
  var body = parseBody(data);

  addObj(body, 'applicants');
});


$(document).ready(function() {
  $('#editModal').on('show.bs.modal', function(event) {
    var button = $(event.relatedTarget); // Get the button that triggered the modal
    var applicantId = button.data('applicant-id');
    var rowValues = getRowValues(applicantId);
    var modal = $(this);
    
    // Set the value of the input field in the modal
    modal.find('#editName').val(rowValues[0]);
    modal.find('#editPhone').val(rowValues[1]);
    modal.find('#editEmail').val(rowValues[2]);
    
    
    
    modal.find('#saveChangesBtn').click(function() {
      var updatedRoleName = modal.find('#editName').val();
      var updatedPhone = modal.find('#editPhone').val();
      var updatedEmail = modal.find('#editEmail').val();
      
      var newData = {
        name: updatedRoleName,
        phone_number: updatedPhone,
        email: updatedEmail
      }

      
      updateObj(applicantId, JSON.stringify(newData), 'applicants')
    });
  });
});


function fillTable(data) {
  var table = $('#applicant-list');
  table.empty();
  if (data.length == 0) {
    table.append(
      `<tr>
      <td colspan="4">No data found</td>
      </tr>`
      )
    }
    
    for (var i = 0; i < data.length; i++) {
      table.append(
        `<tr id="${data[i].id}">
        <td><a href="/applicants/${data[i].id}/">${data[i].name}</a></td>
        <td>${data[i].phone_number}</td>
        <td>${data[i].email}</td>
        
        <td>
        <a data-toggle="modal" data-target="#editModal" data-applicant-id="${data[i].id}" class="text-primary" title="Edit">
        <i class="fas fa-pencil-alt"></i>
        </a>
        <a onclick="deleteObj(${data[i].id},'applicants')" class="text-danger ml-2" title="Delete">
        <i class="fas fa-trash"></i>
        </a>
        </td>
        </tr>`
        
        )
      }
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

