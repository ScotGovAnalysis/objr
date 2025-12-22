# Two-Factor Authentication

(Note: this is sometimes also referred to as ‘two-step verification’.)

## Bypassing 2FA

Where workspaces have two-factor authentication (2FA) enabled,
participants won’t be able to use the API unless they have been given
permission to bypass 2FA.

To check which participants have permission to bypass 2FA, run
[`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md)
using your workspace UUID, and inspect the `bypass_2fa` column in the
returned data frame.

To set up 2FA bypassing in your workspace, you’ll need the help of both
your workgroup administrator and your workspace owner. There are three
main steps to complete this process:

- [Give permission to change 2FA bypass settings in the
  workgroup](#workgroup)
- [Give permission to the workspace owner](#workspace-owner)
- [Give permission to other workspace participants](#participants)

These steps only need to be carried out once before you can use objr (or
the API in general) for the first time.

Before you start, you’ll need the name and UUID for both your workgroup
and workspace. More information on how to find these UUIDs can be found
on the [Getting Started
page](https://scotgovanalysis.github.io/objr/articles/objr.html#universally-unique-identifiers).

### A note for non R users

Some of the required changes can only be made using the API (and not in
the [Objective Connect browser
interface](https://secure.objectiveconnect.co.uk/login)). If either your
Workgroup Admin or Workspace Owner is not an R user, they can use the
API via it’s [interactive
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html)
instead of using objr.

Links to relevant sections of the interactive documentation will be
provided for each step below.

[More detailed guidance to use the interactive
documentation](#interactive) is available in the Getting more help
section.

## Permission to change 2FA settings in the workgroup

These steps must be completed by a **workgroup admin**.

> If you work in the Scottish Government, please [contact the package
> maintainers](https://scotgovanalysis.github.io/objr/authors.html#authors)
> to arrange this step.

1.  Temporarily disable mandatory 2FA in your workgroup. This can be
    done in one of the following ways:

    - Navigate to the summary page for your workgroup in Objective
      Connect. Select ‘Workgroup Options’, un-check the option to
      ‘Enforce Two-step verification’, and click the blue ‘Update’
      button.

    ![A button for 'Workgroup options' is selected. A menu is visible
    containing an option to 'Enforce Two-step verification' with a
    checkbox.](workgroup-2fa.png)

    - In R, use
      [`workgroup_mandate_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_mandate_2fa.md),
      providing the relevant workgroup UUID and setting
      `mandate = FALSE` to disable. For example:

      ``` r
      workgroup_mandate_2fa("v09y-g5vk-5348-k68t-s462-c2vs-7kl8-7440", mandate = FALSE)
      ```

          ## ✔ Mandatory 2FA setting successfully updated for workgroup.

      To reinstate mandatory 2FA later, set `mandate = TRUE`.

      > Non R users can also use the interactive documentation to
      > [disable mandatory 2FA in the
      > workgroup](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Workgroups/setTwoStepMandatory).

2.  In R, allow 2FA bypassing for the workgroup using
    [`workgroup_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/workgroup_bypass_2fa.md),
    providing the relevant workgroup UUID. For example:

    ``` r
    workgroup_bypass_2fa("v09y-g5vk-5348-k68t-s462-c2vs-7kl8-7440")
    ```

        ## ✔ Bypass 2FA setting successfully updated for workgroup.

    > Non R users can use the interactive documentation to [allow 2FA
    > bypassing in the
    > workgroup](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Workgroups/setWorkgroupMfaBypassAllowed).

3.  Continue to the next section to [give the workspace owner permission
    to bypass 2FA](#workspace-owner). Once this is complete, [reinstate
    mandatory 2FA for the workgroup](#workgroup-1).

## Permission for the workspace owner

These steps must be completed by the **workspace owner**.

1.  Navigate to the summary page for your workspace in Objective
    Connect. Select the three dots icon (…) in the top right-hand
    corner, then Two-step verification. When prompted to confirm, select
    Disable.

![A dropdown menu containing an option for 'Two-step verification' among
other options.](workspace-2fa.png)

2.  In R, give yourself (the workspace owner) permission to bypass 2FA
    using
    [`participant_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participant_bypass_2fa.md).
    You will need your participant UUID, which can be found using
    [`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md).
    For example,

    ``` r
    participant_bypass_2fa("z98a-9sy0-b3gv-285m-39k6-20d5-dg6k-3gue")
    ```

        ## ✔ Bypass 2FA setting successfully updated for participant.

    > Non R users can use the interactive documentation to find the
    > relevant [participant
    > UUID](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Participants/getParticipant)
    > and to [allow participant 2FA
    > bypassing](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Participants/setParticipantBypassMfa).

3.  Check this has worked using
    [`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md).
    The `bypass_2fa` column in the returned data frame should contain
    `TRUE` against your name.

    > Non R users can use the interactive documentation to [view
    > participant
    > settings](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Participants/getParticipant).

4.  Reinstate 2FA for the workspace using the [same method as in step
    1](#workspace-1).

5.  The workgroup admin can now [reinstate mandatory 2FA for the
    workgroup](#workgroup-1).

## Permssion for other participants

These steps must be completed by the **workspace owner**.

1.  In R, give participants permission to bypass 2FA using
    [`participant_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participant_bypass_2fa.md).
    You will need the relevant members’ participant UUID, which can be
    found using
    [`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md).

    > Non R users can use the interactive documentation to find the
    > relevant [participant
    > UUID](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Participants/getParticipant)
    > and to [allow participant 2FA
    > bypassing](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html#/Participants/setParticipantBypassMfa).

> For Scottish Government Objective Connect workspaces, bypassing
> permissions should be limited to Scottish Government staff and not
> given to external workspace participants.

If you wish to revoke permissions to bypass 2FA, use
[`participant_bypass_2fa()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participant_bypass_2fa.md)
and set `allow_bypass = FALSE`.

Remember, to check the status of 2FA bypassing for participants in a
workspace, use
[`participants()`](https://ScotGovAnalysis.github.io/objr/dev/reference/participants.md).

## Getting more help

This process can be quite fiddly. If you are unsure or have any issues
with the above, please [contact the package
maintainers](https://scotgovanalysis.github.io/objr/authors.html#authors).

### Using the Interactive Documentation

Some of the required changes can only be made using the API. If either
your Workgroup Admin or Workspace Owner is not an R user, they can use
the API via it’s [interactive
documentation](https://secure.objectiveconnect.co.uk/publicapi/1/swagger-ui/index.html)
instead of using objr.

Links to relevant sections of the interactive documentation are provided
for each step above.

Before using the interactivity, set up API authentication by clicking
the green ‘Authorise’ button (near the top of the page on the right hand
side).

![A screenshot of the interactive API documentation, showing the green
'Authorize' button on the right hand side of the view.](authorize.png)

In the pop-up window, enter your username (usually your email address)
and password for Objective Connect, and click the ‘Authorize’ button.

![A screenshot of the authorisation pop-up window with input boxes to
enter your username and password. An 'Authorize' button is
underneath.](auth-pop-up.png)

To use the API within each section, click the ‘Try it out’ button. You
will then be able to enter values for required parameters.

![A screenshot of the interactive API documentation, showing the 'Try it
out' button on the right hand side of the section for the bypass two
step endpoint. ](try-it-out.png)

Once you have supplied the required information, click the blue
‘Execute’ button to send the API request. Below this you will be able to
see the API response, and whether it has been successful.
