require 'spec_helper'

SEARCH_LDAP_TESTGUY = <<ENTRY
dn: sAMAccountName=testguy,DC=greenplum,DC=com
altsecurityidentities: Kerberos:untitled_1@BARTOL
apple-company: Example Corporation
apple-generateduid: 927107A3-92B4-4285-B153-A5C823369E24
apple-mcxflags:: PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NU
 WVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VO
 IiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4w
 LmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KCTxrZXk+c2lt
 dWx0YW5lb3VzX2xvZ2luX2VuYWJsZWQ8L2tleT4KCTx0cnVlLz4KPC9kaWN0
 Pgo8L3BsaXN0Pgo=
authauthority: ;ApplePasswordServer;0xa1a21c2c8d9411e1940d045453061d87,1024 65537 114574792543369925664970476099531574810470011447394859817353327283009252641939234027203454336596092547412893300748255582830246395307601051059741455985758726565576050698713027643598211823458461426996675470307157668087994612395127920329176467950738294806584152682809589286911571551061068009380246772002575640033 root@bartol.sf.pivotallabs.com:10.80.2.53
authauthority: ;Kerberosv5;0xa1a21c2c8d9411e1940d045453061d87;testguy@BARTOL;BARTOL;1024 65537 114574792543369925664970476099531574810470011447394859817353327283009252641939234027203454336596092547412893300748255582830246395307601051059741455985758726565576050698713027643598211823458461426996675470307157668087994612395127920329176467950738294806584152682809589286911571551061068009380246772002575640033 root@bartol.sf.pivotallabs.com:10.80.2.53
cn: Test Guy
department: Greenery
gidnumber: 21
givenName: Test
homedirectory: 100
loginshell: /bin/bash
userprincipalname: testguy@example.com
objectclass: person
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: posixAccount
objectclass: shadowAccount
objectclass: top
objectclass: extensibleObject
objectclass: apple-user
sn: Guy
title: Big Kahuna
sAMAccountName: testguy
uidnumber: 1026
userpassword:: e0NSWVBUfSo=
ENTRY

SEARCH_LDAP_OTHERGUY = <<ENTRY
dn: sAMAccountName=testguy,DC=greenplum,DC=com
altsecurityidentities: Kerberos:untitled_1@BARTOL
apple-company: Example Corporation
apple-generateduid: 927107A3-92B4-4285-B153-A5C823369E24
apple-mcxflags:: PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPCFET0NU
 WVBFIHBsaXN0IFBVQkxJQyAiLS8vQXBwbGUvL0RURCBQTElTVCAxLjAvL0VO
 IiAiaHR0cDovL3d3dy5hcHBsZS5jb20vRFREcy9Qcm9wZXJ0eUxpc3QtMS4w
 LmR0ZCI+CjxwbGlzdCB2ZXJzaW9uPSIxLjAiPgo8ZGljdD4KCTxrZXk+c2lt
 dWx0YW5lb3VzX2xvZ2luX2VuYWJsZWQ8L2tleT4KCTx0cnVlLz4KPC9kaWN0
 Pgo8L3BsaXN0Pgo=
authauthority: ;ApplePasswordServer;0xa1a21c2c8d9411e1940d045453061d87,1024 65537 114574792543369925664970476099531574810470011447394859817353327283009252641939234027203454336596092547412893300748255582830246395307601051059741455985758726565576050698713027643598211823458461426996675470307157668087994612395127920329176467950738294806584152682809589286911571551061068009380246772002575640033 root@bartol.sf.pivotallabs.com:10.80.2.53
authauthority: ;Kerberosv5;0xa1a21c2c8d9411e1940d045453061d87;testguy@BARTOL;BARTOL;1024 65537 114574792543369925664970476099531574810470011447394859817353327283009252641939234027203454336596092547412893300748255582830246395307601051059741455985758726565576050698713027643598211823458461426996675470307157668087994612395127920329176467950738294806584152682809589286911571551061068009380246772002575640033 root@bartol.sf.pivotallabs.com:10.80.2.53
cn: Other Guy
department: Greenery
gidnumber: 21
givenName: Other
homedirectory: 100
loginshell: /bin/bash
userprincipalname: otherguy@example.com
objectclass: person
objectclass: inetOrgPerson
objectclass: organizationalPerson
objectclass: posixAccount
objectclass: shadowAccount
objectclass: top
objectclass: extensibleObject
objectclass: apple-user
sn: Guy
title: Big Kahuna
sAMAccountName: testguy
uidnumber: 1026
userpassword:: e0NSWVBUfSo=
ENTRY

CUSTOMIZED_LDAP_CHORUS_YML = <<YAML
session_timeout_minutes: 120
instance_poll_interval_minutes: 1
ldap:
  host: 10.32.88.212
  enable: true
  port: 389
  connect_timeout: 10000
  bind_timeout: 10000
  search:
    timeout: 20000
    size_limit: 200
  base: DC=greenplum,DC=com
  user_dn:
  password:
  dn_template: greenplum\\{0}
  attribute:
    uid: sAMAccountName
    ou: department
    gn: givenName
    sn: sn
    cn: cn
    mail: userprincipalname
    title: title

YAML

CUSTOMIZED_LDAPS_CHORUS_YML = <<YAML
session_timeout_minutes: 120
instance_poll_interval_minutes: 1
ldap:
  host: 10.32.88.212
  enable: true
  port: 389
  start_tls: true
  connect_timeout: 10000
  bind_timeout: 10000
  search:
    timeout: 20000
    size_limit: 200
  base: DC=greenplum,DC=com
  user_dn:
  password:
  dn_template: greenplum\\{0}
  attribute:
    uid: sAMAccountName
    ou: department
    gn: givenName
    sn: sn
    cn: cn
    mail: userprincipalname
    title: title

YAML

CUSTOMIZED_LDAP_GROUP_SEARCH_YML = <<YAML
session_timeout_minutes: 120
instance_poll_interval_minutes: 1
ldap:
  enable: true
  url: 10.32.88.212:389
  port: 389
  start_tls: true
  bind:
    username: example_user_dn
    password: secret
  user:
    search_base: ou=Users,dc=example,dc=com
    filter: (uid={0})
  group:
    names: FirstGroup,SecondGroup
    search_base: ou=Groups,dc=example,dc=com
    filter: (memberOf={0})
  connect_timeout: 10000
  bind_timeout: 10000
  search:
    timeout: 20000
    size_limit: 200
  dn_template: greenplum\\{0}
  attribute:
    uid: sAMAccountName
    ou: department
    gn: givenName
    sn: sn
    cn: cn
    mail: userprincipalname
    title: title

YAML

LDAP_WITH_AUTH_CHORUS_YML = <<YAML
session_timeout_minutes: 120
instance_poll_interval_minutes: 1
ldap:
  host: 10.32.88.212
  enable: true
  port: 389
  connect_timeout: 10000
  bind_timeout: 10000
  search:
    timeout: 20000
    size_limit: 200
  base: DC=greenplum,DC=com
  bind:
    username: greenplum\\chorus
    password: secret
  dn_template: greenplum\\{0}
  attribute:
    uid: sAMAccountName
    ou: department
    gn: givenName
    sn: sn
    cn: cn
    mail: userprincipalname
    title: title

YAML

DISABLED_LDAP_CHORUS_YML = <<YAML
session_timeout_minutes: 120
instance_poll_interval_minutes: 1
ldap:
  host: disabled.sf.pivotallabs.com
  enable: false
  port: 389
  connect_timeout: 10000
  bind_timeout: 10000
  search:
    timeout: 20000
    size_limit: 200
  base: DC=bartol,DC=com
  user_dn: greenplum\\chorus
  password: secret
  dn_template: goofy\\{0}
  attribute:
    uid: uid
    ou: department
    gn: givenName
    sn: sn
    cn: cn
    mail: mail
    title: title30573325

YAML

describe LdapClient do
  describe "enabled?" do
    context "when the enable flag is false" do
      before do
        stub(LdapClient).config { YAML.load(DISABLED_LDAP_CHORUS_YML)['ldap'] }
      end

      it "returns false" do
        LdapClient.should_not be_enabled
      end
    end

    context "when the enable flag is true" do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] }
      end

      it "returns true" do
        LdapClient.should be_enabled
      end
    end
  end


  describe "search" do
    before do
      stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] }
    end

    context "when the enable flag is true" do
      let(:entries) { [] }

      before do
        stub(LdapClient).enabled? { true }

        any_instance_of(Net::LDAP) do |ldap|
          stub(ldap).search.with_any_args do |options|
            options[:filter].to_s.should == "(sAMAccountName=testguy)"
            entries
          end
        end
      end

      context "there are no results from the LDAP server" do
        let(:entries) { [] }

        it "should return an empty array" do
          LdapClient.search("testguy").should be_empty
        end
      end

      context "there are multiple matches" do
        let(:entries) { [Net::LDAP::Entry.from_single_ldif_string(SEARCH_LDAP_TESTGUY),
                         Net::LDAP::Entry.from_single_ldif_string(SEARCH_LDAP_OTHERGUY)] }

        before { stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] } }

        it "maps the customized fields to our standardized fields" do
          results = LdapClient.search("testguy")
          results.should be_a(Array)
          results.first.should be_a(Hash)
          results.first.should == {:first_name => "Test",
                                   :last_name => "Guy",
                                   :title => "Big Kahuna",
                                   :dept => "Greenery",
                                   :email => "testguy@example.com",
                                   :username => "testguy",
                                   :auth_method => "ldap"}
          results.last.should be_a(Hash)
          results.last.should == {:first_name => "Other",
                                  :last_name => "Guy",
                                  :title => "Big Kahuna",
                                  :dept => "Greenery",
                                  :email => "otherguy@example.com",
                                  :username => "testguy",
                                  :auth_method => "ldap"}
        end
      end

      context "the LDAP server returns an error" do
        let(:entries) { nil }

        before do
          any_instance_of(Net::LDAP) do |ldap|
            stub(ldap).get_operation_result { OpenStruct.new(:code => 49, :message => 'Invalid Credentials') }
          end
        end

        it "should throw an error" do
          expect {
            LdapClient.search("testguy")
          }.to raise_error(LdapClient::LdapNotCorrectlyConfigured, "Invalid Credentials")
        end
      end
    end

    context "when LDAP is disabled" do
      before do
        stub(LdapClient).enabled? { false }
      end

      it "should raise an error" do
        expect { LdapClient.search("testguy") }.to raise_error(LdapClient::LdapNotEnabled)
      end
    end
  end

  describe "authenticate" do
    context "when the enable flag is true" do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] }
      end
      context "when the LDAP authentication succeeds" do
        it "returns true" do
          any_instance_of(Net::LDAP) do |ldap|
            mock(ldap).auth.with_any_args do |*args|
              args[0].should == "greenplum\\testguy"
              args[1].should == "secret"
              true
            end

            mock(ldap).bind { true }
          end
          stub(LdapClient).enabled? { true }
          stub(LdapConfig).exists? { false }

          LdapClient.authenticate("testguy", "secret").should be_true
        end
      end
    end

    context "when using the group LDAP authentication" do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_GROUP_SEARCH_YML)['ldap']}
        stub(LdapClient).enabled? { true }
        stub(LdapConfig).exists? { true }
      end

      it "trys to bind with the server with the correct user_search_base, filter, and password" do
        any_instance_of(Net::LDAP) do |ldap|
          mock(ldap).bind_as.with_any_args do |*args|
            args[0][:base].should == "ou=Users,dc=example,dc=com"
            args[0][:filter].should == "(uid=example_user_dn)"
            args[0][:password].should == "secret"

            [ OpenStruct.new({ :dn => "example_entry" }) ]
          end
          stub(ldap).bind { true }
        end
        stub(LdapClient).user_in_user_group? { true }
        LdapClient.authenticate("example_user_dn", "secret")
      end

      it "calls search with the group_search_base and group filters" do
        any_instance_of(Net::LDAP) do |ldap|
          stub(ldap).bind { true }
          mock(ldap).search.with_any_args.times(2) do |*args|
            args[0][:base].should =~ /ou=Groups,dc=example,dc=com|uid=example_user,dc=example,dc=com/
            args[0][:filter].to_s.should =~ /\(\|\(memberOf=uid=example,dc=com\)\)|\(cn=(FirstGroup|SecondGroup)/

            [ OpenStruct.new({ :member => ["uid=example,dc=com"], :dn => "uid=example,dc=com" }) ]
          end
        end

        LdapClient.user_in_user_group?(OpenStruct.new( { :dn => "uid=example_user,dc=example,dc=com" }))
      end

      it "throws an error when LDAP can't bind to the server" do
        any_instance_of(Net::LDAP) do |ldap|
          stub(ldap).bind { false }
        end

        expect { LdapClient.authenticate("example_user", "password") }.to raise_error(LdapClient::LdapNotCorrectlyConfigured)
      end

      it "throws a bind error when it can't bind with the correct user" do
        any_instance_of(Net::LDAP) do |ldap|
          stub(ldap).bind_as { false }
          stub(ldap).bind { true }
        end

        expect { LdapClient.authenticate("example_user", "password") }.to raise_error(LdapClient::LdapCouldNotBindWithUser)
      end

      it "throws a membership error if it can't find the user membership" do
        any_instance_of(Net::LDAP) do |ldap|
          stub(ldap).bind_as {
            [ OpenStruct.new({ :dn => "example_entry" }) ]
          }
          stub(ldap).bind { true }
        end
        stub(LdapClient).user_in_user_group? { false }


        expect { LdapClient.authenticate("example_user", "password") }.to raise_error(LdapClient::LdapCouldNotFindMember)
      end
    end

    context "when LDAP is disabled" do
      before do
        stub(LdapClient).enabled? { false }
      end

      it "should raise an error" do
        expect { LdapClient.authenticate("testguy", "secret") }.to raise_error(LdapClient::LdapNotEnabled)
      end
    end
  end

  describe "client" do
    context "when we user_dn and password are not specified" do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] }
        LdapClient.config["user_dn"].should be_blank
        LdapClient.config["password"].should be_blank
      end

      it "uses anonymous auth" do
        mock(Net::LDAP).new(hash_including(:auth => {:method => :anonymous}))
        LdapClient.client
      end
    end

    context "when the bind.username and bind.password are specified" do
      before do
        stub(LdapClient).config { YAML.load(LDAP_WITH_AUTH_CHORUS_YML)['ldap'] }
        LdapClient.config["bind"]["username"].should_not be_blank
        LdapClient.config["bind"]["password"].should_not be_blank
      end

      it "uses simple auth" do
        mock(Net::LDAP).new(hash_including(:auth => {:method => :simple, :username => LdapClient.config["bind"]["username"], :password => LdapClient.config["bind"]["password"]}))
        LdapClient.client
      end
    end

    context 'with standard config' do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAP_CHORUS_YML)['ldap'] }
      end

      it 'uses host and port to connect' do
        mock(Net::LDAP).new.with_any_args do |params|
          params.should include :host => '10.32.88.212'
          params.should include :port => 389
          params.should_not include :encryption
        end

        LdapClient.client
      end
    end

    context 'with ldaps config' do
      before do
        stub(LdapClient).config { YAML.load(CUSTOMIZED_LDAPS_CHORUS_YML)['ldap'] }
      end

      it 'uses :encryption' do
        mock(Net::LDAP).new.with_any_args do |params|
          params.should include :host => '10.32.88.212'
          params.should include :port => 389
          params.should include :encryption => :start_tls
        end

        LdapClient.client
      end
    end
  end

  describe "with a local ApacheDS ldap server" do
    before(:all) do
      @ldap_server = Ladle::Server.new().start
    end

    after(:all) do
      @ldap_server.stop if @ldap_server
    end

    it "" do end
    it "" do end
    it "" do end
    it "" do end
    it "" do end
    it "" do end

  end
end