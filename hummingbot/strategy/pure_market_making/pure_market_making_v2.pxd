# distutils: language=c++

from libc.stdint cimport int64_t

from hummingbot.strategy.strategy_base cimport StrategyBase
from hummingbot.core.data_type.order_book cimport OrderBook

from .order_filter_delegate cimport OrderFilterDelegate
from .order_pricing_delegate cimport OrderPricingDelegate
from .order_sizing_delegate cimport OrderSizingDelegate
from .asset_price_delegate cimport AssetPriceDelegate


cdef class PureMarketMakingStrategyV2(StrategyBase):
    cdef:
        dict _market_infos
        bint _all_markets_ready
        bint _hanging_orders_enabled
        bint _order_optimization_enabled
        bint _add_transaction_costs_to_orders
        object _limit_order_type

        double _cancel_timestamp
        double _create_timestamp
        double _order_refresh_time
        double _expiration_seconds
        double _status_report_interval
        double _last_timestamp
        double _filled_order_delay
        double _hanging_orders_cancel_pct
        double _order_refresh_tolerance_pct
        object _order_optimization_depth
        dict _time_to_cancel
        list _hanging_order_ids

        int64_t _logging_options

        OrderFilterDelegate _filter_delegate
        OrderPricingDelegate _pricing_delegate
        OrderSizingDelegate _sizing_delegate
        AssetPriceDelegate _asset_price_delegate

    cdef c_execute_orders_proposal(self,
                                   object market_info,
                                   object orders_proposal)
    cdef object c_get_penny_jumped_pricing_proposal(self,
                                                    object market_info,
                                                    object pricing_proposal,
                                                    list active_orders)
    cdef tuple c_check_and_add_transaction_costs_to_pricing_proposal(self,
                                                                     object market_info,
                                                                     object pricing_proposal,
                                                                     object sizing_proposal)
    cdef object c_filter_orders_proposal_for_takers(self, object market_info, object orders_proposal)
    cdef object c_create_orders_proposals(self, object market_info, list active_orders)
    cdef bint c_is_within_tolerance(self, list current_orders, list proposals)
    cdef c_cancel_active_orders(self, object market_info, object orders_proposal)
    cdef c_cancel_hanging_orders(self, object market_info)
    cdef bint c_to_create_orders(self, object market_info, object orders_proposal)
