# Script to append the first element of a list to the end
$('#nav ul li:first').appendTo('#nav ul');

# Copy first element in the list to the end of the list
$('#nav ul li:first').clone().appendTo('#nav ul');

# Copy first element in the list to the end of the list along with the related data and events
$('#nav ul li:first').clone(true).appendTo('#nav ul');
