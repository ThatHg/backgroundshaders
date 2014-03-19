Shader "Background/ThreeButtons"
{
	// This is outside variables i.e. from Unity C# script and what nots.
	Properties
	{
		// Colors
		_col0	("First Color", Color)		= (1,0,0,1)	// Red
		_col1	("Second Color", Color)		= (0,1,0,1)	// Green
		_col2	("Third Color", Color)		= (0,0,1,1)	// Blue
		_col3	("Fourth Color", Color)		= (0,1,1,1)	// Yellow
		
		// Distance between primitives
		_dist	("Distance", float)			= 3.7
		
		// Zooming
		_zoom	("Zoom", float)				= 1
		
		// General speed
		_speed	("General Speed", float)	= 1
		
		// Music rythm, intensity of music
		_rythm	("Music Rythm", float)		= 1
		
		// Resolution of viewport
		_width	("Viewport Width", float)	= 1
		_height ("Viewport Height", float)	= 1
		
		// Position on screen
		_posx	("Position X", float)		= 1
		_posy	("Position Y", float)		= 1
	}

	SubShader
	{
		Pass
		{
			Name "Colors"
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma glsl
			#pragma target 3.0
			
			// Denfines for better readability in sourcecode
			#define WHITE float4(1.)
			#define GRAY float4(.3)
			#define BLACK float4(0.)
			#define numRows 20
			#define numCols 20

			#include "UnityCG.cginc"
			
			// Outside variables
			float4 	_col0;
			float4 	_col1;
			float4	_col2;
			float4	_col3;
			float	_dist;
			float	_speed;
			float	_zoom;
			float	_rythm;
			float	_width;
			float	_height;
			float	_posx;
			float	_posy;
			
			float period;
			float halfperiod;
			
			struct VsIn
			{
				float4 vertex : POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			struct VsOut
			{
				float4 position : SV_POSITION;
				float4 texcoord0 : TEXCOORD0;
			};

			VsOut vert(VsIn i)
			{
				VsOut o;
				o.position = mul (UNITY_MATRIX_MVP, i.vertex);
				o.texcoord0 = (i.texcoord0 * _zoom);
				return o;
			}

			float4 frag(VsOut i) : COLOR
			{
				period = 2.;
				halfperiod = period * 0.5;
				float dt = fmod(_Time.y, period);
				float dth = fmod(_Time.y, halfperiod);

				int moveFlip = int(fmod(_Time.y, period * 2.0) > period);
				int moveRows = int(fmod(_Time.y, period) > halfperiod);
				int moveEvens = int(fmod(_Time.y, period) > halfperiod);

				if (moveFlip > 0)
				{
					moveEvens = 1 - moveEvens;
				}
				
				float dx = _width / float(numRows);
				float dy = _height / float(numCols);
				
				float x = i.texcoord0.x;
				float y = i.texcoord0.y;
				
				x *= _width/_height;
				
				
				int rowx = int(x / dx);
				int rowy = int(y / dy);
				
				int xeven = int(fmod(float(rowx), 2.0));
				int yeven = int(fmod(float(rowy), 2.0));
				
				float t = dth / halfperiod  + _rythm * 0.1;
				
				float dtx = dx * t * 2.0;
				float dty = dy * t * 2.0;
				
				if (moveEvens == 1)
				{
					if (moveRows == 1 && xeven == 1)
					{
						y = y + dty;
						rowy = int(y / dy);
					}
					else if (moveRows == 0 && yeven == 0)
					{
						x = x + dtx;
						rowx = int(x / dx);
					}
				}
				else
				{
					if (moveRows == 1 && xeven == 0)
					{
						y = y + dty;
						rowy = int(y / dy);
					}
					else if (moveRows == 0 && yeven == 1)
					{
						x = x + dtx;
						rowx = int(x / dx);
					}
				}

				xeven = int(fmod(float(rowx), 2.0));
				yeven = int(fmod(float(rowy), 2.0));
				
				float4 col = float(1.);
				
				if (xeven == yeven)
				{
					if(fmod(_Time.y, 2.) > 1.)
						col = _col0;
					else
						col = _col1;
				}
				else if(xeven > yeven)
				{
					if(fmod(_Time.y, 2.) > 1.)
						col = _col1;
					else
						col = _col2;
				}
				else
				{
					if(fmod(_Time.y, 2.) > 1.)
						col = _col2;
					else
						col = _col0;
				}
				
				return col;
			}
			ENDCG
		}
	}
}

