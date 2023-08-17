public class AccountContact {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String phone { get; set; }
    public String email { get; set; }
    public String website { get; set; }
    public String language { get; set; }
    public List<Account> createdCustomers { get; private set; }

    public void createAccount() {
        // Validate phone number (10-digit) and email format
        if (!Pattern.matches('^\\d{10}$', phone)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Phone number must be 10 digits'));
            return;
        }
        
        if (!Pattern.matches('[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}', email)) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email format'));
            return;
        }

        Account acc = new Account(Name = firstName + ' ' + lastName, Phone = phone, Website = website, Language__c = language);
        insert acc;

        Contact con = new Contact(AccountId = acc.Id, FirstName = firstName, LastName = lastName , Phone = phone, Email = email);
        insert con;

        // Clear form fields after creation
        firstName = '';
        lastName = '';
        phone = '';
        email = '';
        website = '';
        language = '';

        // Fetch created customer information
        createdCustomers = [SELECT Name, Phone, Website, Language__c FROM Account WHERE Id = :acc.Id LIMIT 1];
    }

}