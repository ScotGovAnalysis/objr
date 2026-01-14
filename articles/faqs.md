# Frequently Asked Questions

## What is the difference between users and participants?

A user is an individual using Objective Connect. A participant is a user
in a particular workspace. For example, a person using Objective Connect
will have a User UUID associated with them, and also a Participant UUID
for each individual workspace they are a member of.

A user can get their User UUID by running
[`my_user_id()`](https://ScotGovAnalysis.github.io/objr/reference/my_user_id.md).
A user can find their participant UUID for a particular workspace using
[`participants()`](https://ScotGovAnalysis.github.io/objr/reference/participants.md).

## Can I use the objr package to interact with eRDM?

Unfortunately, no. Although both eRDM and Connect are
[Objective](https://www.objective.co.uk/) products, their API’s are
considerably different. The objr package currently works for Objective
Connect only, although it may be developed in the future to work with
eRDM.

## Can I use objr with two-factor or mobile authentication?

Yes. The following articles provide more information on how to use
these:

- [Two-factor
  authentication](https://ScotGovAnalysis.github.io/objr/articles/two-factor.md)

- [Mobile
  authentication](https://ScotGovAnalysis.github.io/objr/articles/authentication.html#mobileauth)
