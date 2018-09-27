using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class PostProcessing : MonoBehaviour {

    Material mat;
    [SerializeField, Range(0,1)]
    float NegativeAmount = .3f;

	// Use this for initialization
	void Start ()
    {
        mat = new Material(Shader.Find("Hidden/NegativePost"));
	}
	
    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int negativeParam = Shader.PropertyToID("_NegativeAmount");
        mat.SetFloat(negativeParam, NegativeAmount);

        Graphics.Blit(source, destination, mat);
    }
}
