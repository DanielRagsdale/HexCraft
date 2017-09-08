module util.time;

import core.time;

static
{
    alias MonoTime = MonoTimeImpl!(ClockType.normal);
}

public static double CurrentTime()
{
    MonoTime currentTime = MonoTime.currTime;

    return cast(double)currentTime.ticks() / currentTime.ticksPerSecond();
}
