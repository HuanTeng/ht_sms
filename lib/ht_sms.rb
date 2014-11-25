require 'ht_sms/version'
require 'ht_sms/duan_xin_bao'

module HtSMS

    Emitter = DuanXinBao
    Test = Rails.env.test?

    def self.send_sms(phone, message, async=true, &block)
        if Test
            fake_send_sms(phone, message, block)
        elsif defined?(HtSMS.method(:delay)) && async
            HtSMS.delay.send_sms_proxy(phone, message, block)
        else
            send_sms_proxy(phone, message, block)
        end
    end

    private

    def send_sms_proxy(phone, message, &block)
        phones, single = plural_phone(phone)
        result = { 'count' => phones.length }

        valid_phones, ivalid_phones = filter_phone_number(phones)
        ivalid_phones.each {|p| result["#{p}"] = 'ivalid phone number'}

        result.merge emit_sms(valid_phones, message)

        result = errors[0] if single
        yield(result) if block_given?
        nil
    end

    def emit_sms(phones, message, &block)
        if Emitter.method(:send_multi_sms)
            result = Emitter.send_multi_sms(phones, message)
        else
            result = {}
            phones.each do |phone|
                result.merge Emitter.send_single_sms(phone, message)
            end
        end
        result
    end

    def fake_send_sms(phone, message, &block)
        phones, single = plural_phone(phone)
        result = { 'count' => phones.length}
        phones.each {|p| result["#{p}"] = nil}

        result = errors[0] if single
        yield(result) if block_given?
        nil
    end

    def plural_phone(phone)
        single = phone.class != Array ? false : true
        phone = [phone] if single
        return phones, single
    end

    def filter_phone_number(phones)
        valid_phones = []
        ivalid_phones = []

        phones.each do |phone|
            if validate_phone_number(phone)
                valid_phones << phone
            else
                ivalid_phones << phone
            end
        end
        return valid_phone, ivalid_phones
    end

    def validate_phone_number(phone_number)
        n = phone_number.to_s
        n.length == 11 && /^1\d+$/.match(n)
    end

end
