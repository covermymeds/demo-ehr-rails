Demo EHR Rails Example
============

This application demonstrates what a typical web-based EHR can do to automate prior authorization using the [CoverMyMeds EHR API](https://api.covermymeds.com).


### Dependencies
* Ruby on Rails
* PostgreSQL
* [api-jquery-plugins](https://git.innova-partners.com/cmm/api-jquery-plugins)

### Tests

* Ruby version 2.0.0-p481
* Rails version 4.1.1
* Bundler
* phantom.js (`brew install phantomjs`)

Run `bundle install` to install all of the gem dependencies.

### Installation

First, see [Heroku Postgres](http://postgresapp.com/) for installing Postgres on your platform. Once that is installed, you can install Ruby and Rails, and the gems that are bundled.

Run postgres and create the required user:

    CREATE ROLE demoehrrails LOGIN CREATEDB;

Run `bundle install` if you have not installed the gem dependencies. The application is written for Rails 4.1.1. When the bundle is completed, run:

    bundle exec rake db:setup

You'll need to obtain your own unique API keys, which must be stored in environment variables that the server can access. You can obtain your API keys at [api.covermymeds.com/your-account](https://api.covermymeds.com/your-account).

Once your API keys are set in the environment, you can run `bundle exec rspec` to run through the tests.

To start the server, run `bundle exec rails server`.


### Distribution

This file is distributed as-is with no warranty, express or implied. If you wish to deploy this code, Heroku is a nice choice, but any Rails host will do.

### Walkthrough

This is a simple demo system to show how to integrate CoverMyMeds into your system using the CoverMyMeds API.

You will need to create four interface elements:

1. a button to start a prior authorization while the provider is working with an electronic prescription,
2. a prior authorization task list which will be used to show the PAs being worked upon,
3. a form to start a new prior authorization, and
4. a contact page so CoverMyMeds can help your users.

#### e-Prescribing - Patients

The example EHR application gives you the ability to manage patients. The following goes through the workflow of managing patients, prescriptions, and prior authorization requests.

Route: `/patients`

The patient list view shows patients witin the EHR system. Each patient has a count beside their name. This indicates the number of PA requests associated with this patient.

From this view you can add a patient by clicking on the green "Add Patient" button at the top. Removing a patient can be done by clicking on the red "Remove" button to the right of the patient name.

Route: `/patients/:id`

Clicking on a patient will direct you to the patient's show view. There are two possible scenarios when arriving to this view. If the patient does not have any prescriptions associated to their record you will be prompted to add one. However, if the patient has associated prescriptions you will be directed to a list of prescriptions for that patient along with their statuses.

Route `/patients/new`

If there are no prescriptions present you will be asked to create a new prescription for that patient. On this page the drug and form search plugins are used. One thing to consider is that in order for the form search to make a successful query a drug must be selected from the drug search field.

To see an example of how the drug and form search plugins are used, see `/app/assets/javascripts/pa_requests.js` and `/app/assets/javascripts/prescriptions.js`.

If there are prescriptions present then a list of the patient's prescriptions are shown. From here you can change and add prescriptions, or you can select the prescriptions to start a PA for.

When creating a new prescription, clicking the checkbox "Start PA" causes a new PA to be started using the CoverMyMeds API Create Request endpoint. When the prescription is submitted the example application gathers the prescriptions and sends them off to be filled. The logic behind this is in the `PrescripionsController`.

Route: `/requests/new `

Allows you to add a single prior authorization request. The drug and form search plugins are used here as well as the create request plugin. When the form is filled out and the request is successful you will be redirected to the task list or dashboard page.

Route: `/request-pages`

The Request Pages resource provides the ability to completely embed the CoverMyMeds workflow within your EHR's own user interface. This API returns a UI-agnostic description of a request at a particular point in the workflow, along with a set of actions the user can take to move the request through to the next workflow. Based on the idea of Hypermedia APIs, Request Pages lends the strength of CoverMyMeds' years of experience in managing workflows to your EHR.

#### Dashboard/Task List

Route: `/dashboard`

This page demonstrates using the dashboard plugin to build a task list of PA requests with options for filtering, searching, and sorting. See `/app/assets/javascripts/pa_requests.js` for an example of using the dashbord plugin.

#### Contact CoverMyMeds

Under the menu "Resources" are links to the resources you might need to build your own application.  You can find documentation, contacts at CoverMyMeds, and a link to the source code.

If you decide to integrate your EHR with CoverMyMeds' PA functionality, please contact us before you go live so we can discuss business terms.
