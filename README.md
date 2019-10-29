# pivexemption

PIV Exemption Portal

## Jamf Pro Items
### Smart Group

**- PIV Exemption Portal**
    - Smart Computer Group that looks at the "Smartcard-Exempt - Reason" EA for "Jamf Admin:"

### Policies

**- Start PIV Exemption**
    - Script: StartExemption.sh
    - Frequency: Once a week
    - Trigger: Check-in
    - Scope: PIV Exemption Portal Smart Group

**- Remove PIV Exemption**
    - Script: ExemptionRemoval.sh
    - Search for com.jamf.exemptioncheck.plist and delete if found
    - Run Unix command 'rm -f /Library/Scripts/checkDate.sh'
    - Frequency: Ongoing
    - Trigger: removeExemption
    - Scope: PIV Exemption Portal Smart Group


### Extension Attributes
**- Smartcard-exempt**
    - Type: Integer / Pop-up Menu
    - Choices:
        - 0
        - 1
    - Used to trigger the Exemption Configuration Profile

**- Smartcard-exempt - Justification Category**
    - Type: Pop-up Menu
    - Add choices to be used. Will also be used with the PIV Exemption Portal

**- Smartcard-exempt - Reason**
    - Type: Text Field
    - Used to store input from the PIV Exemption Portal that is also used in the Smart Computer Group criteria

### Scripts

**- ExemptionRemoval.sh**
    - Removes the exemption. Used in the Remove PIV Exemption policy

**- StartExemption.sh**
    - Starts the exemption. Used in the Start PIV Exemption policy