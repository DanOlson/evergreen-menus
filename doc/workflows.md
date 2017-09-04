## Typical Workflows

This document outlines some typical use cases of Beermapper.

### Establishment Management

#### Creating an Establishment

```
As a restaurant manager
I want to create an Establishment
So that I can start using Beermapper's features
```

* Login as Manager
* Click "Add Establishment" button
* Fill in Establishment details
  * Using a real address is beneficial, because it will be geocoded to a latitude/longitude pair and will appear on the map when search results match on beermapper.com
  * Note: Buttons to create Lists, Menus, and Digital Display Menus will be disabled until the new Establishment is saved.
* Click the "Create" button

#### Adding Lists

```
As a restaurant manager (or staff)
I want to create Lists
So that I can promote the beers I serve in a variety of ways
```

* Login as Manager
* Click on one of your Establishments
* In the "Lists" panel, click the "Add New" button
* Give your List a name
* Choose whether you want the price and description of each List item to appear on your website
* Click the "+" button to begin adding Beers
* Add as many Beers as you want, then click the "Create" button

```
As a restaurant manager (or staff)
I want to add my Lists to my website
So that my site is always up to date with my current beer selection
```

* Login as Manager
* Click on your Establishment
* In the "Lists" panel, click the scissors icon to reveal the embed code for each list
* Copy the embed code, and paste it into your website's source code
* Once your website's changes are live, your Lists in Beermapper will drive your website's menu content

```
As a restaurant manager (or staff)
I want to make updates to my Lists
So that my various menus are accurate
```

* Login as Manager
* Click on your Establishment
* In the "Lists" panel, click on the List you wish to edit
* Make any necessary changes
  * Update the List's name, "show/hide" settings, Beer names/prices/descriptions
  * Add new Beers by clicking the "+" button
  * Remove outdated Beers by clicking the appropriate "x" button
* Click the "Update" button
* All changes are now immediately available across all menus containing that List

#### Composing Menus

```
As a restaurant manager (or staff)
I want to create PDF menus
So that I can inform my guests of our beer selection
```

* Login as Manager
* Click on your Establishment
* In the "Menus" panel, click the "Add New" button
* Give the Menu a name
* Choose a font, font size, and number of columns
* The "Available Lists" panel shows all of your Establishent's Lists. Add a List to the Menu by clicking the "+" button next to its name.
* The "Lists Selected" panel shows all the lists on this Menu. Remove a List by clicking the "-" button next to its name.
* Depending on the number of Beers on the Menu, you may want to change the settings for font, font size, or number of columns.
* Click the "Create" button
* A "Download" button will now appear. Click it to download the Menu as a PDF to your computer.

#### Composing Digital Display Menus

```
As a restaurant manager (or staff)
I want TVs inside my bar to show various menus
So that I can entice my guests with our beer selection
```

* Login as Manager
* Click on your Establishment
* In the "Digital Display Menus" panel, click the "Add New" button
* Give the Digital Display Menu a name
* Choose a screen orientation and a rotation interval
* The "Available Lists" panel shows all of your Establishent's Lists. Add a List to the Menu by clicking the "+" button next to its name.
* The "Lists Selected" panel shows all the lists on this Menu. Remove a List by clicking the "-" button next to its name.
* Click the "Create" button
* A "View Display" button will now appear. Click it to navigate to your Digital Display Menu.

### User Management

#### Inviting Users

```
As a restaurant manager
I want to invite my staff to access my Beermapper account
So that they may manage menu content for appropriate establishments
```

* Login as Manager
* Click the "Staff" tab in the header
* Click the "Invite Staff" button
* Fill in the staff member's first name, last name, and email address
* Choose which Establishments the staff member will be allowed to access
* Choose "Invite another" if you'd like to invite more staff members
* Click the "Invite" button

An email will be sent to the address you entered into the invitation form containing a link to sign up with Beermapper. Once the invitation has been accepted, the new staff member will have the "Staff" role, and will have access to the Establishments you specified in the invitation. Invitations can be edited before they're accepted, and can also be revoked if necessary.

#### Editing an Invitation

```
As a restaurant manager
I want to edit an open invitation
So that I can change the Establishments the invitee will have access to
```

* Login as Manager
* Click the "Staff" tab in the header
* In the "Pending Invitations" panel, click the name of the person you invited.
* Edit details, including first name, last name, and Establishments to which you're granting access
* Click the "Update" button

#### Deleting an Invitation

```
As a restaurant manager
I want to delete an invitation
So that I don't grant access to someone who shouldn't have it. (sent it to the wrong email, staff quit, etc.)
```

* Login as Manager
* Click the "Staff" tab in the header
* In the "Pending Invitations" panel, click the name of the person you invited.
* Click the "Delete" button
* Confirm you want to delete the invitation

#### Editing Users

```
As restaurant manager
I want to grant a staff member access to additional Establishments on my account
So that they can manage the menus of those Establishments
```

* Login as Manager
* Click the "Staff" tab in the header
* In the "Staff" panel, click on the name of the person you wish to edit
* Choose the appropriate set of Establishments the person should be allowed to access
* Click the "Update" button

```
As restaurant manager
I want to change the Role of one of my employees
So that they can have the appropriate access level for their duties
```

* Login as Manager
* Click the "Staff" tab in the header
* In the "Staff" panel, click on the name of the person you wish to edit
* Choose the appropriate Role for the person (Manager or Staff)
* Click the "Update" button

#### Changing your password

```
As a User of Beermapper
I want to change my password
So that my account is secure
```

* Login
* Click your name at the right side of the header
* Enter a new password
* Enter the same password again to confirm it
* Enter your current password
* Click the "Update" button

#### Resetting a forgotten password

```
As a User of Beermapper who forgot their password
I want to reclaim my access
So that I can continue using the application
```

* Visit https://admin.beermapper.com/users/sign_in
* Click the "Forgot your password?" link
* Enter the email address of your profile
* Click the "Send reset password instructions" button
* Follow link enclosed in the password reset email
* Choose a new password
