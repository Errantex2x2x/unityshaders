using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class FireCam : MonoBehaviour
{

    Material mat;
    [SerializeField, Range(0, 1)]
    float FireAmount = .3f;
    [SerializeField]
    RenderTexture targetTexture;

    // Use this for initialization
    void Start()
    {
        mat = new Material(Shader.Find("Hidden/FireCam"));
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        int fireTextureParam = Shader.PropertyToID("_FireTex");
        mat.SetTexture(fireTextureParam, targetTexture);

        int negativeParam = Shader.PropertyToID("_FireAmount");
        mat.SetFloat(negativeParam, FireAmount);

        Graphics.Blit(source, destination, mat);
    }
}
