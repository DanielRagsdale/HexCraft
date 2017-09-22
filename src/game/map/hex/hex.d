

class Hex
{
	ushort id;
	string identifier;

	bool isSolid;

	public this(ushort id, string str)
	{
		this(id, str, true);
	}

	public this(ushort id, string str, bool solid)
	{
		this.id = id;
		this.identifier = str;
		this.isSolid = solid;
	}

	/**
	 * Is this block a solid block, similar to dirt or stone
	 **/
	public bool IsSolidHex()
	{
		return isSolid;
	}

	public int GetRenderFunction()
	{
		return 0;
	}

	/**
	 * Get the texture ID based upon the face;
	 **/
	public ushort GetTexture(int face)
	{
		return id;
	}
}
