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

$('#search').submit(function(e) {
    e.preventDefault();
    var query = $('#search-input').val();
    searchUser(query);
});


function storeUniversities(response) {
    // Map university ids to university names
    for (var i = 0; i < response.length; i++) {
        universities[response[i].id] = response[i].name;
    }
    searchUser('');
}

function searchUser(query) {
    var data = {
        "user_id": user_id,
        "user_name": query
    }

    $.ajax({
        url: '/api/search_user',
        method: 'POST',
        data: JSON.stringify(data),
        success: function(response) {
            fillTable(response);
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}


function fillTable(response) {
    var table = $('#users-table');
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
            var user = response[i];
            var row = $('<tr id="user-' + user.id + '"></tr>');
            row.append('<td>' + user.name + '</td>');
            if (user.uni_id == null) {
                row.append('<td>---</td>');
            } else {
                row.append('<td>' + universities[user.uni_id] + '</td>');
            }
            if (user.can_follow == true) {
                row.append(`
                    <td>
                        <a onclick="followUser(${user.id})" class="text-primary" title="Follow">
                            <i class="fas fa-plus"></i>
                        </a>
                    </td>`
                );
            } else {
                row.append(`
                    <td>
                        <a onclick="unfollowUser(${user.id})" class="text-danger" title="Unfollow">
                            <i class="fas fa-minus"></i>
                        </a>
                    </td>`
                );
            }
            tbody.append(row);
        }
    }
}

function followUser(userId) {
    var data = {
        "follower_id": user_id, 
        "followee_id": userId
    }
    $.ajax({
        url: '/api/follow_user',
        method: 'POST',
        data: JSON.stringify(data),
        success: function(response) {
            window.location.reload();
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}

function unfollowUser(userId) {
    var data = {
        "follower_id": user_id, 
        "followee_id": userId
    }
    $.ajax({
        url: '/api/unfollow_user',
        method: 'POST',
        data: JSON.stringify(data),
        success: function(response) {
            window.location.reload();
        },
        error: function(xhr, status, error) {
            alert('Error: ' + xhr.responseJSON.name[0]);
        }
    });
}