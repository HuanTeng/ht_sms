require 'minitest/autorun'
require_relative '../lib/ht_sms.rb'

class HtSmsTest < MiniTest::Test

    def setup; end
    def teardown; end


    def test_methods_exist
        assert_equal 'method', defined?(HtSms.send_sms)
        assert_equal 'method', defined?(HtSms.send_sms_proxy)
        assert_equal 'method', defined?(HtSms.emit_sms)
        assert_equal 'method', defined?(HtSms.plural_phone)
        assert_equal 'method', defined?(HtSms.filter_phone_number)
        assert_equal 'method', defined?(HtSms.validate_phone_number)
    end

    def test_validate_phone_number
        assert_equal true, HtSms.validate_phone_number(18612345678)
        assert_equal true, HtSms.validate_phone_number('18612345678')
        assert_equal false, HtSms.validate_phone_number('186123456789')
        assert_equal false, HtSms.validate_phone_number(1861234567)
        assert_equal false, HtSms.validate_phone_number('21861234567')
        assert_equal false, HtSms.validate_phone_number('1861234567a')
    end

    def test_filter_phone_number
        phones = ['13212345678', '[13212345678]', '13212345679', '1321234567a', '???']
        valid_phones, ivalid_phones = HtSms.filter_phone_number(phones)
        assert_equal ['13212345678', '13212345679'], valid_phones
        assert_equal ['[13212345678]', '1321234567a', '???'], ivalid_phones
    end

    def test_plural_phone
        assert_equal [['13212345678'], true], HtSms.plural_phone('13212345678')
        assert_equal [['13212345678'], false], HtSms.plural_phone(['13212345678'])
        assert_equal [['13212345678', '???'], false], HtSms.plural_phone(['13212345678', '???'])
    end

    def test_emit_sms
        result = HtSms.emit_sms(['13212345678', '13212345679'], 'some msg')
        assert_equal nil, result['13212345678']
        assert_equal nil, result['13212345679']
    end

    def test_send_sms_proxy
        HtSms.send_sms_proxy(['13212345678', '13212345679'], 'some msg') do |result|
            assert_equal 2, result['count']
            assert_equal nil, result['13212345678']
            assert_equal nil, result['13212345679']
            assert_equal true, result.keys.include?('13212345678')
            assert_equal true, result.keys.include?('13212345679')
        end
    end

    def test_send_sms
        # TODO: send real SMS
    end
end
