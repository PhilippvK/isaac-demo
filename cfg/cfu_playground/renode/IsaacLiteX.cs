using Antmicro.Renode.Core;
using Antmicro.Renode.Logging;
using Antmicro.Renode.Peripherals.Bus;
using Antmicro.Renode.Peripherals.UART;

namespace Antmicro.Renode.Peripherals.UART
{
    // Renode's pinned LiteX UART transmits synchronously and never fills its
    // TX FIFO. Complete that model with LiteX's newer TX-empty status register.
    public class IsaacLiteXUART : LiteX_UART, IDoubleWordPeripheral, IBytePeripheral
    {
        public IsaacLiteXUART(IMachine machine) : base(machine) {}
        public new uint ReadDoubleWord(long offset)
        {
            return offset == 0x18 ? 1u : base.ReadDoubleWord(offset);
        }
        public new byte ReadByte(long offset)
        {
            return offset == 0x18 ? (byte)1 : base.ReadByte(offset);
        }
    }
}

namespace Antmicro.Renode.Peripherals.Miscellaneous
{
    // Mirror the simulator's finish CSR for functional validation. The runner
    // uses bounded virtual time; this marker proves firmware reached its end.
    public class IsaacFinish : IDoubleWordPeripheral, IKnownSize
    {
        public uint ReadDoubleWord(long offset) { return Value; }
        public void WriteDoubleWord(long offset, uint value)
        {
            Value = value;
            this.Log(LogLevel.Info, "ISAAC_CFU_FINISH={0}", value);
        }
        public void Reset() { Value = 0; }
        public uint Value { get; private set; }
        public long Size { get { return 4; } }
    }
}
