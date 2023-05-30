var user_id = 1;
var universities = {};
$(document).ready(function() {
    $.ajax({
        url: '/api/list_universities',
        method: 'GET',
        success: function(response) {
            storeUniversities(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
});

function storeUniversities(response) {
    // Map university ids to university names
    for (var i = 0; i < response.length; i++) {
        universities[response[i].id] = response[i].name;
    }
    listFollowers();
}

function listFollowers() {
    $.ajax({
        url: '/api/list_followers?user_id=' + user_id,
        method: 'GET',
        success: function(response) {
            fillTable(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function fillTable(data) {
    var table = $('#followers-table');
    var tbody = table.find('tbody');
    tbody.empty();

    if (data.length === 0) {
        tbody.append(
            `<tr>
                <td colspan="9">No users found</td>
            </tr>`
        );
    } else {
        for (var i = 0; i < data.length; i++) {
            var user = data[i];
            var row = $(`<tr id="user-${user.id}"></tr>`);
            row.append("<td>" + user.name + "</td>");
            if (user.uni_id == null) {
                row.append('<td>---</td>');
            } else {
                row.append('<td>' + universities[user.uni_id] + '</td>');
            }

            tbody.append(row);
        }
    }
}