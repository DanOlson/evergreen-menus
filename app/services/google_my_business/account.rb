module GoogleMyBusiness
  class Account
    attr_reader :name,
                :account_name,
                :type,
                :role,
                :state,
                :permission_level

    def initialize(args)
      @name = args['name']
      @account_name = args['accountName']
      @type = args['type']
      @role = args['role']
      @state = args['state']
      @permission_level = args['permissionLevel']
    end
  end
end
