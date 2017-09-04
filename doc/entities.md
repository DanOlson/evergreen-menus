## Entities in the system

### Account

The root entity is the Account. The account represents a paying customer organization. An account can have a name, and an active status. Other entities in the system are related the account. Related entities include the following:

  * Users
  * Establishments

### User

A User is an entity that represents a person employed by, or acting unbehalf of, the paying customer organization (Account). They are the ones behind the keyboard, directly using the application. A user will have one of three roles, Admin, Manager, or Staff. Each role encapsulates a different set of permissions, and roles are hierarchical. More on Roles below.

A User belongs to an Account, and depending on their Role, can manipulate the Account or its related entities in different ways. Users can not access an Account to which they do not belong, or any of those Accounts' entities.

### Establishment

An Establishment belongs to an Account. An Account can have many Establishments. Establishments represent a single bar or restaurant, and are more or less the main entity within the application. Establishments have a name, address information, and the following child entities:

  * Lists
  * Menus (PDFs)
  * Digital Display Menus (HDTV menus)

### List

Lists are arguably the most important entity in the system. Lists are how establishments group the various Beers (or other menu items) they serve. An Establishment might have a "Taps" list, a "Bottles" list, a "Wine" list, a "Happy Hour" list, and many more. As a User updates their lists by adding or removing Beers, the changes are automatically reflected everywhere the list is displayed.

Lists are displayed in the following ways:

  * Each List a user creates will come with an "embed code" which can easily be added to the Establishment's existing website. As the list is updated, the changes are automatically reflected on the Establishment's website.
  * Lists can be added to Menus. Users can create PDF Menus by combining lists of their choice. Updates to the Lists are automatically reflected on the Menu PDF.
  * Lists can be added to Digital Display Menus. As with PDF Menus, Digital Display Menus are created by combining Lists, and are automatically updated along with the Lists that they contain.

Lists belong to an Establishment, and an Establishment can have many Lists. Additionally, all Beers added to an Establishment's Lists will appear in search results on beermapper.com

### Menu

Menus are combinations of Lists that are rendered to a PDF to be printed and placed at the bar or tables. Any changes to Lists that compose the Menus are reflected automatically within the Menu. A Menu belongs to an Establishment, and an Establishment can have many Menus.

### Digital Display Menu

Digital Display Menus are combinations of Lists that are designed to be displayed on in-house HDTVs (within the Establishment). Lists are shown one at a time, and are rotated so that each List gets equal airtime. Any changes to Lists that compose the Digital Display Menus are reflected automatically. A Digital Display Menu belongs to an Establishment, and an Establishment can have many Digital Display Menus.

### Roles

#### Staff

The Staff role would be given to an employee or agent of the Establishment that would be allowed or responsible for keeping the various menus up-to-date. Staff are granted access to select Establishments by Managers.

For Establishments that a User with the Staff role has access to, they may:

  * Create, Edit, and Delete Lists
  * Create, Edit, and Delete Menus
  * Create, Edit, and Delete Digital Display Menus
  * Edit the Establishment
  * View the Account
  * Edit their profile

Users with the Staff role may not:

  * Create Establishments
  * Edit the Account
  * View a List's "embed code"

#### Manager

The Manager role would be given to a User who oversees the operations of the Establishment, or is in charge of administrating the Beermapper account. It represents an elevated set of permissions vs the Staff role.

A user with the Manager role may:

  * do everything the Staff role can do
  * Create Establishments
  * Edit the Account
  * View a List's "embed code"
  * View the Account's current Users
  * Edit and Delete User profiles for the Account (including changing their roles)
  * Invite new Users

#### Admin

The Admin role is given to a User in charge of administering Beermapper as a whole. Admin Users are not restricted by Account, and have all access within the application. Admin role cannot be granted by any other User, and would not be granted to customers at all.

A user with the Admin role may:

  * do everything the Manager role can do
  * Create, Edit, and Delete all Accounts
