import eensy.{Up, get_system_platform}

import gleam/option.{None, Some}
import gleam/result

import eensy/gpio.{type Level, High, Low}
import eensy/store
import gleam/erlang/process

// Model -----------------------------------------------------------------------

pub type Model {
  Model(led: Level)
}

// Start -----------------------------------------------------------------------

pub fn start() -> Nil {
  let _ = do_start()
  process.sleep_forever()
}

fn do_start() {
  let default_model = Model(led: Low)

  // State Store actor
  use store <- result.try(store.start(default_model))

  // Internal Led actor
  use gpio_led <- result.try(
    gpio.start(gpio.pin(
      level: Low,
      pull: Up,
      port: internal_blink_pin(),
      direction: gpio.Output,
      update: None,
    )),
  )

  process.start(fn() { loop_internal_led(store:, gpio_led:) }, False)

  Ok(Nil)
}

fn loop_internal_led(
  store store: store.StoreActor(Model),
  gpio_led gpio_led: gpio.PinActor(Model, msg),
) {
  use model <- result.try(store.get(store))
  gpio.write(gpio_led, model.led)

  process.sleep(300)
  store.set(
    store,
    Model(led: case model.led {
      High -> Low
      Low -> High
    }),
  )
  loop_internal_led(store, gpio_led)
}

fn internal_blink_pin() {
  case get_system_platform() {
    eensy.Esp32 | eensy.Pico -> 2
    _ -> 0
  }
}
