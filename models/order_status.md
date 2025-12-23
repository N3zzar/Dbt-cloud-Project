{% docs order_status %}

### Order Status

The `order_status` field represents the **current lifecycle state of an order** from creation through delivered or cancellation.

This field is sourced from the transactional ordering system and reflects the **latest known state** of each order at the time of data ingestion.

---

### Possible Values

| Status        | Description                                                   |
| ------------- | ------------------------------------------------------------- |
| `created`     | Order record has been created but not yet processed           |
| `approved`    | Payment has been authorized                                   |
| `processing`  | Order is being prepared for shipment                          |
| `invoiced`    | Invoice has been generated                                    |
| `shipped`     | Order has been shipped to the carrier                         |
| `delivered`   | Order has been successfully delivered to the customer         |
| `canceled`    | Order was canceled before fulfillment                         |
| `unavailable` | Order could not be fulfilled due to stock or logistics issues |

---

### Business Rules

- An order is considered **successful** only when `order_status = 'delivered'`.
- Orders with `canceled`, or `unavailable` statuses are **excluded from revenue calculations**.

{% enddocs %}
