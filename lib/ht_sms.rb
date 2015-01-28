require 'ht_sms/version'
require 'ht_sms/misc'
require 'ht_sms/config'
require 'ht_sms/duan_xin_bao'

module HtSms

    # useage: HtSms.send_sms(13212345678, 'hello kitty')
    # only expose one method: HtSms.send_sms

    # Emitter = point to SMS client
    Emitter = DuanXinBao

    def self.send_sms(phone, message, async=true, &block)
        if defined?(HtSms.method(:delay)) && async
            HtSms.delay(queue: 'tracking', priority: 0).send_sms_proxy phone, message do |r|
                block.call(r) if block_given?
            end
        else
            send_sms_proxy phone, message do |r|
                block.call(r) if block_given?
            end
        end
    end
end
